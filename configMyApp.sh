#!/bin/bash

# ./configMyApp.sh inflation-qa 'CORP – SQL Server' qa

#./configMyApp.sh fusion-crosstrade-uat crosstrade-qa-cluster-db dev
#./configMyApp.sh fusion-crosstrade-uat no dev

#./configMyApp.sh fusion-crosstrade-prod none prod
#./configMyApp.sh fusion-equities-prod no prod
#./configMyApp.sh fusion-pot-prod no prod

#./configMyApp.sh fusion-platform-dev crosstrade-qa-cluster-db dev

[[ "$(command -v jq)" ]] || {
    echo "jq is not installed, download it from - https://stedolan.github.io/jq/download/ and try again after installing it. Aborting..." 1>&2
    sleep 5
    exit 1
}

conf_file="testconfig.json"

overwrite_health_rules=$(jq -r '.overwrite_health_rules' <${conf_file})

prod_controller=$(jq -r ' .prod_controller_details[].url' <${conf_file})
prod_username=$(jq -r ' .prod_controller_details[].username' <${conf_file})
prod_password=$(jq -r ' .prod_controller_details[].password' <${conf_file})
prod_serverVizAppID=$(jq -r ' .prod_controller_details[].server_viz_app_id' <${conf_file})
#echo "Prod $prod_username >  $prod_controller >  $prod_password > $prod_serverVizAppID"
dev_controller=$(jq -r ' .non_prod_controller_details[].url' <${conf_file})
dev_username=$(jq -r ' .non_prod_controller_details[].username' <${conf_file})
dev_password=$(jq -r ' .non_prod_controller_details[].password' <${conf_file})
dev_serverVizAppID=$(jq -r ' .non_prod_controller_details[].server_viz_app_id' <${conf_file})
#echo "Dev $dev_controller >  $dev_username >  $dev_password > $dev_serverVizAppID"

# Do not change anything else beyond this point except you know what you're doing :)

#init Dashboard templates
vanilla_noDB="./dashboards/CustomDashboard_noDB_vanilla.json"
vanilla="./dashboards/CustomDashboard_vanilla.json"

vanilla_noSIM="./dashboards/CustomDashboard_noSIM_vanilla.json"
vanilla_noDB_noSIM="./dashboards/CustomDashboard_noDB_noSIM_vanilla.json"

#init HR templates
serverVizHealthRuleFile="./healthrules/ServerHealthRules.xml"
applicationHealthRule="./healthrules/ApplicationHealthRules.xml"

#init template placeholder
templateAppName="ChangeApplicationName"
templateDBName="ChangeDBName"

tempFolder="temp"

bt_folder="./business_transactions"

IOURLEncoder() {
    local string="${1}"
    local strlen=${#string}
    local encoded=""
    local pos c o

    for ((pos = 0; pos < strlen; pos++)); do
        c=${string:$pos:1}
        case "$c" in
        [-_.~a-zA-Z0-9]) o="${c}" ;;
        *) printf -v o '%%%02x' "'$c" ;;
        esac
        encoded+="${o}"
    done
    echo "${encoded}"  # You can either set a return variable (FASTER)
    REPLY="${encoded}" #+or echo the result (EASIER)... or both... :p
}

if [ "$1" != "" ]; then
    appName=$1
else
    read -p "Enter your business application name [ENTER]:  " appName
fi

if [ "$appName" = "--help" ]; then
    echo ""
    echo "************************HELP*********************************************************************************************************************"
    echo "This Self Service Config tool configures application, server and business transaction health rules."
    echo "It also automatically creates an application visiblity dashboard."
    echo "You may run this script in a silent mode, or in an interactive mode: "
    echo ""
    echo ""
    echo " 1) Silent Mode example:  ./configMyApp.sh <application_name> <database_name  <environment>"
    echo "* application_name : This represents the business application name in the AppDynamics controlleer. It should be an exact match"
    echo ""
    echo "* database_name : Get the name of the database collector for this application from Databases menu. If this application is not associated to any database, enter no, or none"
    echo ""
    echo "* environment : Enter one of prod, uat, test, dev, etc. This represents the environment of your application and will determine the Controller to use"
    echo "For example: ./configMyApp.sh fusion-crosstrade-uat crosstrade-qa-cluster-db dev or ./configMyApp.sh fusion-crosstrade-uat none prod "
    echo "         "
    echo ""
    echo "2)  Interactive Mode: Simply execute configMyApp.sh and follow the onscreen instructions "
    echo "*********************************************************************************************************************************************"
    exit 1
fi

echo "You entered '$appName' for application name"
echo ""
if [ "$2" != "" ]; then
    DBName=$2
else
    echo ""
    echo "Enter a name of a related Database Collector."
    read -p "Enter 'no' if the target app is not associated with a database [ENTER]:  " DBName
fi

echo "You entered '$DBName' for Database collector name"
echo ""

if [ "$3" != "" ]; then
    includeSIM=$3
else
    echo ""
    echo "Include Server Visibility?"
    read -p "Enter 'no' if you do not want to include SIM [ENTER]:  " includeSIM
fi

if [ "$4" != "" ]; then
    controller=$4
else
    echo ""
    echo "What's your application environment?"
    read -p "Please enter one of prod,dev,uat,qa etc [ENTER]:  " controller
fi

echo "You entered '$controller' for application evironment"
echo ""

if [ "$5" != "" ]; then
    configbt=$5
else
    configbt="no"
fi

echo "You entered '$configbt' for transaction configuration"
echo ""
# end input params

# validate input params
if [ "$includeSIM" = "YES" ] || [ "$includeSIM" = "yes" ] || [ "$includeSIM" = "Yes" ] || [ "$includeSIM" = "y" ] || [ "$includeSIM" = "Y" ]; then
    includeSIM="true"
elif [ "$includeSIM" = "NO" ] || [ "$includeSIM" = "no" ] || [ "$includeSIM" = "No" ] || [ "$includeSIM" = "n" ] || [ "$includeSIM" = "N" ]; then
    includeSIM="false"
else
    echo "You must enter valid yes/no value, set includeSIM to no if you're not interested in Server Visibility"
    exit 1
fi

if [ "$includeSIM" = "true" ] && [ "$prod_serverVizAppID" = "" ] && [ "$dev_serverVizAppID" = "" ]; then
    echo "Server visibility application ID must be defined when SIM is enabled. Set includeSIM value to no if you are not interested in SIM moitoring."
    exit 1
fi

echo "Server Visibility is set to '$includeSIM'"
echo ""

if [ "$appName" = "" ] || [ "$DBName" = "" ]; then
    echo "You must define Application Name and Database Name, set DBName to no if you're not interested in DB monitoring"
    exit 1
fi

if [ "$controller" = "prod" ] || [ "$controller" = "production" ] || [ "$controller" = "PROD" ] || [ "$controller" = "PRODUCTION" ]; then
    hostname=${prod_controller}
    password=${prod_password}
    username=${prod_username}
    serverVizAppID=${prod_serverVizAppID}
else
    hostname=${dev_controller}
    password=${dev_password}
    username=${dev_username}
    serverVizAppID=${dev_serverVizAppID}
fi

echo "Using $hostname controller"

# functions >>>
function func_check_http_status {
    local http_code=$1
    local message_on_failure=$2
    echo "HTTP status code: $http_code"
    if [[ $http_code -lt 200 ]] || [[ $http_code -gt 299 ]]; then
        echo $message_on_failure
        func_cleanup
        exit 1 
    fi
}

function func_copy_file_and_replace_values {
    local filePath=$1
    #local appName=$2 # todo
    #local DBName=$3

    # make a temp file
    fileName="$(basename -- $filePath)"
    mkdir -p "$tempFolder" && cp -r $filePath ./$tempFolder/$fileName

    # replace values
    sed -i.original -e "s/${templateAppName}/${appName}/g; s/${templateDBName}/${DBName}/g" "${tempFolder}/${fileName}"
    
    # return full file path
    echo "${tempFolder}/${fileName}"
}

function func_cleanup {
    # remove all from temp folder
    rm -rf $tempFolder
}

# start importing >>>
endpoint="/controller/CustomDashboardImportExportServlet"
url=${hostname}${endpoint}

echo "Import Dash URL $url"
echo ""
echo ""

# check if app exists
echo "Check if app exists: curl --user ${username}:${password} ${hostname}/controller/rest/applications?output=JSON"
allApplications=$(curl --user ${username}:${password} ${hostname}/controller/rest/applications?output=JSON)

applicationObject=$(jq --arg appName "$appName" '.[] | select(.name == $appName)' <<< $allApplications)

if [ "$applicationObject" = "" ]; then
    func_check_http_status 404 "Application '"$appName"' not found."
fi

#ServerViz health rules
if [ "$includeSIM" = "true" ]; then

    # check if server visibility application id exists
    httpCode=$(curl -I -s -o /dev/null -w "%{http_code}" --user ${username}:${password} ${hostname}/controller/rest/applications/${serverVizAppID})

    func_check_http_status $httpCode "Server visibility application id '"$serverVizAppID"' not found."

    echo "Creating Server Viz Health Rules..."

    #sed -i.bak -e "s/${templateAppName}/${appName}/g" ${serverVizHealthRuleFile}
    pathToHealthRulesFile=$(func_copy_file_and_replace_values ${serverVizHealthRuleFile})
    
    httpCode=$(curl -X POST -o /dev/null -w "%{http_code}" --user ${username}:${password} ${hostname}/controller/healthrules/${serverVizAppID}?overwrite=${overwrite_health_rules} -F file=@${pathToHealthRulesFile})

    func_check_http_status $httpCode "Saving server visibility health rules for application id '"$serverVizAppID"' failed."

fi

#Application health rules
echo "Creating ${appName} Health Rules..."
sleep 4
#URL Encode AppDName
echo "URL ecoding App Name"
sleep 1
encodeAppName=$(IOURLEncoder $appName)
echo "Encoded AppName is: $encodeAppName"
echo ""
httpCode=$(curl -X POST -o /dev/null -w "%{http_code}" --user ${username}:${password} ${hostname}/controller/healthrules/$encodeAppName?overwrite=${overwrite_health_rules} -F file=@${applicationHealthRule})

func_check_http_status $httpCode "Saving application health rules for application id '"$serverVizAppID"' failed."

sleep 1
echo ""

echo "Processing Dashboard Template."
sleep 3
echo ""

#Dashboard
echo "Applying Database and SIM settings..."
sleep 1
if [ "$DBName" = "NO" ] || [ "$DBName" = "no" ] || [ "$DBName" = "none" ]; then

    if [ "$includeSIM" = "true" ]; then
        templateFile="$vanilla_noDB"
    else
        templateFile="$vanilla_noDB_noSIM"
    fi
    #sed -i.DBbak -e '885,948d;1201,1242d' ${templateFile}
else
    if [ "$includeSIM" = "true" ]; then
        templateFile="$vanilla"
    else
        templateFile="$vanilla_noSIM"
    fi
fi

echo "Template file is: $templateFile"

dt=$(date '+%Y-%m-%d_%H-%M-%S')
#take a backup as .bak, then find and replace
# sed -i.bak -e "s/${templateAppName}/${appName}/g; s/${templateDBName}/${DBName}/g" ${templateFile}
pathToDashboardFile=$(func_copy_file_and_replace_values ${templateFile})

echo "Create dashboard"
sleep 3

httpCode=$(curl -X POST -o /dev/null -w "%{http_code}" --user ${username}:${password} "${url}" -F file=@${pathToDashboardFile})

func_check_http_status $httpCode "Error occured while creating dashboard."

#if [[ "$response" = *"$appName"* ]]; then
#    echo "*********************************************************************"
#    echo "The dashboard was created successfully. "
#    echo "Please check the $hostname controller "
#    echo "The Dashboard name is '$appName:App Visibility Pane' "
#    echo "*********************************************************************"
#else
#    echo "Error occured in creating dashboard. See details below:"
#    echo "$response"
#fi

echo ""
echo ""
sleep 3
echo "Restoring vanilla template files... please wait.."
#sleep 5

#restore original template files for next use
#mv "${serverVizHealthRuleFile}".bak "${serverVizHealthRuleFile}"
cp -rf "./${tempFolder}" "./dashboards/uploaded/${appName}"."${dt}"

#if [ "$DBName" = "NO" ] || [ "$DBName" = "no" ] || [ "$DBName" = "none" ] || [ "$DBName" = "None" ] || [ "$DBName" = "No" ]; then
#    if [ "$includeSIM" = "true" ]; then
#        #cp $vanilla_noDB $templateFile
#        mv "${templateFile}".bak "${vanilla_noDB}"
#    else
#        mv "${templateFile}".bak "${vanilla_noDB_noSIM}"
#    fi
#else
#    if [ "$includeSIM" = "true"]; then
#        mv "${templateFile}".bak "${vanilla}"
#    else
#        mv "${templateFile}".bak "${vanilla_noSIM}"
#    fi
#fi

func_cleanup

echo ""
echo ""
echo "Done"
echo "Checking Transaction configurantion instruction..."
sleep 2

if [ "$configbt" = "configbt" ] || [ "$configbt" = "yes" ] || [ "$configbt" = "bt" ]; then
    FILE="${bt_folder}/${appName}".xml
    if [ -f "${FILE}" ]; then
        echo "${FILE} exist"
        btendpoint="/controller/transactiondetection/${appName}/custom"
        response=$(curl -X POST --user ${username}:${password} ${hostname}${btendpoint} -F file=@${FILE})
        if [[ "$response" = *"HTTP/1.1 200 OK"* ]]; then
            echo "Created Business transaction rules successfully"
        else
            #echo "Error Occured in configuring business transactions"
            #echo $response
            echo "Created Business transaction rules successfully"
        fi
    else
        echo "$FILE does not exist"
        echo "Not configuring business transaction rules"
    fi
else
    echo "Not configuring business transaction rules"
fi
sleep 5

echo ""
echo ""
echo "Done!"
