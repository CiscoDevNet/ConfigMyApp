#!/bin/bash

# ./configMyApp.sh inflation-qa 'CORP – SQL Server' qa

#./configMyApp.sh fusion-crosstrade-uat crosstrade-qa-cluster-db dev
#./configMyApp.sh fusion-crosstrade-uat no dev

#./configMyApp.sh fusion-crosstrade-prod none prod
#./configMyApp.sh fusion-equities-prod no prod
#./configMyApp.sh fusion-pot-prod no prod

#./configMyApp.sh IoTHub ConfigMyApp yes dev

#./configMyApp.sh fusion-platform-dev crosstrade-qa-cluster-db dev

#./configMyApp.sh IoTHub no no dev configbtonly

[[ "$(command -v jq)" ]] || {
    echo "jq is not installed, download it from - https://stedolan.github.io/jq/download/ and try again after installing it. Aborting..." 1>&2
    sleep 5
    exit 1
}

[[ "$(command -v base64)" ]] || {
    echo "base64 is not installed. Please ensure that you have 'base64' installed on this machine. Aborting..." 1>&2
    sleep 5
    exit 1
}

[[ "$(command -v awk)" ]] || {
    echo "awk is not installed, ConfigMyApp requires awk to be installed. Aborting..." 1>&2
    sleep 5
    exit 1
}

conf_file="./config.json"

# overwrite_health_rules=$(jq -r '.overwrite_health_rules' <${conf_file})
# are_passwords_encoded=$(jq -r '.are_passwords_encoded' <${conf_file})

enable_branding=$(jq -r ' .branding[].enabled' <${conf_file})
image_logo_path="./branding/$(jq -r ' .branding[].logo_file_name' <${conf_file})"
image_background_path="./branding/$(jq -r ' .branding[].background_file_name' <${conf_file})"

# prod_controller=$(jq -r ' .prod_controller_details[].url' <${conf_file})
# prod_username=$(jq -r ' .prod_controller_details[].username' <${conf_file})
# prod_password=$(jq -r ' .prod_controller_details[].password' <${conf_file})

# dev_controller=$(jq -r ' .non_prod_controller_details[].url' <${conf_file})
# dev_username=$(jq -r ' .non_prod_controller_details[].username' <${conf_file})
# dev_password=$(jq -r ' .non_prod_controller_details[].password' <${conf_file})

# dev_proxy_url=$(jq -r ' .non_prod_controller_details[].proxy_ur'l <${conf_file})
# dev_proxy_port=$(jq -r ' .non_prod_controller_details[].proxy_port' <${conf_file})

# Do not change anything else beyond this point except you know what you're doing :)

#init Dashboard templates
vanilla_noDB="./dashboards/CustomDashboard_noDB_vanilla.json"
vanilla="./dashboards/CustomDashboard_vanilla.json"

vanilla_noSIM="./dashboards/CustomDashboard_noSIM_vanilla.json"
vanilla_noDB_noSIM="./dashboards/CustomDashboard_noDB_noSIM_vanilla.json"

#init HR templates
serverVizHealthRuleFile="./healthrules/ServerVisibility/*.json"
applicationHealthRule="./healthrules/Application/*.json"

#init template placeholder
templateAppName="ChangeApplicationName"
templateDBName="ChangeDBName"
templateBackgroundImageName="ChangeImageUrlBackground"
templatLogoImageName="ChangeImageUrlLogo"

tempFolder="temp"
bt_folder="./business_transactions"

dt=$(date '+%Y-%m-%d_%H-%M-%S')


### START GETTING INPUT ARGUMENTS ###
_controller_url=$1 # hostname + /controller

_user_credentials=$2 # ${username}:${password}

_proxy_details=$3 # proxy_details

_application_name=$4 # appName
_include_database=$5 # 
_database_name=$6 # DBName
_include_sim=$7 # includeSIM
_configure_bt=$8 # 
_overwrite_health_rules=$9 # overwrite_health_rules

# echo "URL $_controller_url"
# echo "CREDS $_user_credentials"
# echo "BT $_configure_bt"
# echo "Proxy $_proxy_details"
# echo "APP $_application_name"

### END GETTING INPUT ARGUMENTS ###

### START FUNCTIONS ###
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

function encode_image() {
    local image_path=$1

    $(chmod 775 $image_path)

    image_extension="$(file -b $image_path | awk '{print $1}')"

    if [ $(is_image_valid $image_extension) = "False" ]; then
        echo "Image extension '$image_extension' of an '$image_path' not supported."
        exit 1
    fi

    #echo "Image extension '$image_extension' of '$image_path' ....."
    local image_prefix="data:image/png;base64,"
    echo | base64 -w0 >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        # GNU coreutils base64, '-w' supported
        local encoded_image="$(base64 -w 0 $image_path)"
        #local encoded_image="$(openssl base64 -A -in $image_path)"
    else
        # MacOS Openssl base64, no wrapping by default
        local encoded_image="$(base64 $image_path)"
    fi

    echo "${image_prefix} ${encoded_image}"
}

function is_image_valid() {
    declare -a image_extension_collection=("JPG" "JPEG" "PNG")

    local image_extension=$1

    if [[ ${image_extension_collection[$image_extension]} ]]; then echo "True"; else "False"; fi
}

# if [ "$1" != "" ]; then
#     appName=$1
# else
#     read -p "Enter your business application name [ENTER]:  " appName
# fi

# if [ "$appName" = "--help" ]; then
#     echo ""
#     echo "************************HELP*********************************************************************************************************************"
#     echo "This Self Service Config tool configures application, server and business transaction health rules."
#     echo "It also automatically creates an application visiblity dashboard."
#     echo "You may run this script in a silent mode, or in an interactive mode: "
#     echo ""
#     echo ""
#     echo " 1) Silent Mode example:  ./configMyApp.sh <application_name> <database_name> <server_viz> <environment>"
#     echo "* application_name : This represents the business application name in the AppDynamics controlleer. It should be an exact match"
#     echo ""
#     echo "* database_name : Get the name of the database collector for this application from Databases menu. If this application is not associated to any database, enter no, or none"
#     echo ""
#     echo "* server_viz : Enter yes to configure server viz health rules"
#     echo ""
#     echo "* environment : Enter one of prod, uat, test, dev, etc. This represents the environment of your application and will determine the Controller to use"
#     echo "For example: ./configMyApp.sh AD-DevOps 'Ecomm Oracle DB' yes dev or ./configMyApp.sh AD-DevOps no no prod "
#     echo "         "
#     echo ""
#     echo "2)  Interactive Mode: Simply execute configMyApp.sh and follow the onscreen instructions "
#     echo "*********************************************************************************************************************************************"
#     exit 1
# fi

# echo "You entered '$appName' for application name"
# echo ""
# if [ "$2" != "" ]; then
#     DBName=$2
# else
#     echo ""
#     echo "Enter a name of a related Database Collector."
#     read -p "Enter 'no' if the target app is not associated with a database [ENTER]:  " DBName
# fi

# echo "You entered '$DBName' for Database collector name"
# echo ""

# if [ "$3" != "" ]; then
#     includeSIM=$3
# else
#     echo ""
#     echo "Include Server Visibility?"
#     read -p "Enter 'no' if you do not want to include SIM [ENTER]:  " includeSIM
# fi

# if [ "$4" != "" ]; then
#     controller=$4
# else
#     echo ""
#     echo "What's your application environment?"
#     read -p "Please enter one of prod,dev,uat,qa etc [ENTER]:  " controller
# fi

# echo "You entered '$controller' for application evironment"
# echo ""

# if [ "$5" != "" ]; then
#     configbt=$5
# else
#     configbt="no"
# fi

# echo "You entered '$configbt' for transaction configuration"
# echo ""

# end input params

# validate input params
# if [ "$DBName" = "NO" ] || [ "$DBName" = "no" ] || [ "$DBName" = "No" ] || [ "$DBName" = "n" ] || [ "$DBName" = "N" ] || [ "$DBName" = "" ] || [ "$DBName" = "none" ] || [ "$DBName" = "nodb" ] || [ "$DBName" = "NODB" ]; then
#     inludeDB="false"
# else
#     inludeDB="true"
# fi

# if [ "$includeSIM" = "YES" ] || [ "$includeSIM" = "yes" ] || [ "$includeSIM" = "Yes" ] || [ "$includeSIM" = "y" ] || [ "$includeSIM" = "Y" ] || [ "$includeSIM" = "sim" ] || [ "$includeSIM" = "SIM" ] || [ "$includeSIM" = "Sim" ]; then
#     includeSIM="true"
# elif [ "$includeSIM" = "NO" ] || [ "$includeSIM" = "no" ] || [ "$includeSIM" = "No" ] || [ "$includeSIM" = "n" ] || [ "$includeSIM" = "N" ] || [ "$includeSIM" = "nosim" ] || [ "$includeSIM" = "NOSIM" ] || [ "$includeSIM" = "Nosim" ]; then
#     includeSIM="false"
# else
#     echo "You must enter valid yes/no value, set includeSIM to no if you're not interested in Server Visibility"
#     exit 1
# fi

# echo "Server Visibility is set to '$includeSIM'"
# echo ""

# if [ "$appName" = "" ] || [ "$DBName" = "" ]; then
#     echo "You must define Application Name and Database Name, set DBName to no if you're not interested in DB monitoring"
#     exit 1
# fi

# if [ "$controller" = "prod" ] || [ "$controller" = "production" ] || [ "$controller" = "PROD" ] || [ "$controller" = "PRODUCTION" ]; then
#     hostname=${prod_controller}
#     password=${prod_password}
#     username=${prod_username}
#     proxy_url="${prod_proxy_url}"
#     proxy_port="${prod_proxy_port}"
# else
#     hostname=${dev_controller}
#     password=${dev_password}
#     username=${dev_username}
#     proxy_url="${dev_proxy_url}"
#     proxy_port="${dev_proxy_port}"
# fi

# # decode passwords if encoded
# if [ "$are_passwords_encoded" = "true" ]; then
#     password=$(eval echo ${password} | base64 --decode)
# fi

# echo "Using $hostname controller"
# echo ""
# echo ""

function func_check_http_status() {
    local http_code=$1
    local message_on_failure=$2
    #echo "HTTP status code: $http_code"
    if [[ $http_code -lt 200 ]] || [[ $http_code -gt 299 ]]; then
        echo $message_on_failure
        func_cleanup
        exit 1
    fi
}

function func_check_http_response(){
    local http_message_body="$1"
    local string_success_response_contains="$2"
    if [[ "$http_message_body" =~ "$string_success_response_contains" ]]; then # contains
            echo "*********************************************************************"
            echo "Success"
            echo "*********************************************************************"
        else
            echo "${dt} ERROR "{$http_message_body}"" >> error.log
            echo "ERROR $http_message_body"
            func_cleanup
            exit 1
        fi
}

function func_find_file_by_name() {
    local imgName=$1

    result=$(find ./branding -name "*${imgName}*.[png|jpg|jpeg]*" | head -n 1)

    echo $result
}

function func_copy_file_and_replace_values() {
    local filePath=$1

    # make a temp file
    fileName="$(basename -- $filePath)"
    mkdir -p "$tempFolder" && cp -r $filePath ./$tempFolder/$fileName

    if [ "$enable_branding" = "true" ]; then

        encodedBackgroundImageUrl="$(encode_image $image_background_path)"
        encodedLogoImageUrl="$(encode_image $image_logo_path)"

        echo "\"$encodedBackgroundImageUrl\"" >"${tempFolder}/backgroundImage.txt"
        echo "\"$encodedLogoImageUrl\"" >"${tempFolder}/logoImage.txt"

        # replace background picture
        sed -i.bkp -e "/${templateBackgroundImageName}/r ./${tempFolder}/backgroundImage.txt" -e "/${templateBackgroundImageName}/d" "${tempFolder}/${fileName}"

        # replace logo
        sed -i.bkp -e "/${templatLogoImageName}/r ./${tempFolder}/logoImage.txt" -e "/${templatLogoImageName}/d" "${tempFolder}/${fileName}"
    fi

    # replace application and database name
    sed -i.original -e "s/${templateAppName}/${_application_name}/g; s/${templateDBName}/${_database_name}/g" "${tempFolder}/${fileName}"

    # return full file path
    echo "${tempFolder}/${fileName}"
}

function func_cleanup() {
    # remove all from temp folder
    rm -rf $tempFolder
}

function func_import_health_rules(){
    local appId=$1
    local folderPath=$2

     # get all current health rules for application
    allHealthRules=$(curl -s --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${appId}/health-rules ${_proxy_details})

    for f in $folderPath; do 

        # get health rule name from json file
        healthRuleName=$(jq -r  '.name' <$f)
        # use it to get health rule id (if exists)
        healthRuleId=$(jq --arg hrName "$healthRuleName" '.[] | select(.name == $hrName) | .id' <<<$allHealthRules)

        # create new if health rule id does not exist
        if [ "${healthRuleId}" == "" ]; then
            httpCode=$(curl -s -o /dev/null -w "%{http_code}" -X POST --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${appId}/health-rules --header "Content-Type: application/json" --data "@${f}" ${_proxy_details})
            func_check_http_status $httpCode "Error occured while importing server health rules."
        # overwrite existing health rule only if flag is true
        elif [ "${_overwrite_health_rules}" = true ]; then
            httpCode=$(curl -s -o /dev/null -w "%{http_code}" -X PUT --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${appId}/health-rules/${healthRuleId} --header "Content-Type: application/json" --data "@${f}" ${_proxy_details})
            func_check_http_status $httpCode "Error occured while importing server health rules."
        fi

    done
}

### END FUNCTIONS ###

# Process proxy details
#j q sets empty strings to null istead of NULL
# echo "Please wait while we check if you've configured any proxies with ConfigMyApp"
# sleep 1
# if [ -z "$proxy_url" ] || [ "$proxy_url" = "null" ] || [ -z "$proxy_port" ] || [ "$proxy_port" = "null" ] || [ "$proxy_port" = "" ] || [ "$proxy_url" = "" ]; then
#     echo "No HTTP Proxy is configured. Skipping proxy configuration..."
#     proxy_details=""
# else
#     echo "Found HTTP Proxy configuration, using... "
#     echo "Proxy URL = $proxy_url , Proxy Port = $proxy_port"
#     proxy_details="-x $proxy_url:$proxy_port"
# fi

endpoint="/CustomDashboardImportExportServlet"
url=${_controller_url}${endpoint}

echo ""
echo ""

# check if app exists
echo "Checking if ${_application_name} business application exist in ${_controller_url}..."
echo ""
echo ""
sleep 1


allApplications=$(curl -s --user ${_user_credentials} ${_controller_url}/rest/applications?output=JSON ${_proxy_details})

applicationObject=$(jq --arg appName "$_application_name" '.[] | select(.name == $appName)' <<<$allApplications)

if [ "$applicationObject" = "" ]; then
    func_check_http_status 404 "Application '"$_application_name"' not found. Aborting..."
fi

appId=$(jq '.id' <<<$applicationObject)

echo "Found ${_application_name} business application"
echo ""
echo ""

#if [ "$configbt" = "configbtonly" ] || [ "$configbt" = "only" ] || [ "$configbt" = "btonly" ] || [ "$configbt" = "onlybt" ]; then

if [ "${_configure_bt}" = true ]; then
    echo ""
    echo "You entered $_configure_bt. This instruction will ONLY configure business transaction in $_application_name"
    echo "Application health rules, SIM health rules, dashboard, etc will not be created..."
    echo ""
    echo "Please wait while we process your Business transaction configuration settings from the JSON file"
    echo ""
    sleep 2
    source ./configBT.sh "$_application_name"
else
    #proceed as normal

    #Server Visibility health rules
    if [ "${_include_sim}" = true ]; then
        echo "Creating Server Visibility Health Rules...Please wait"
        echo ""

        func_import_health_rules $appId "${serverVizHealthRuleFile}"
    fi

    #Application health rules
    echo ""
    echo "Creating ${_application_name} Health Rules..."
    sleep 1

    func_import_health_rules $appId "${applicationHealthRule}"

    echo ""
    sleep 1
    echo "done"

    echo ""
    echo "Processing Dashboard Template."
    sleep 3
    echo ""

    #Dashboard
    echo "Applying Database and SIM settings to the dashboard template..."
    sleep 1
    if [ "${_include_database}" = false ]; then

        if [ "${_include_database}" = true ]; then
            templateFile="$vanilla_noDB"
        else
            templateFile="$vanilla_noDB_noSIM"
        fi
    else
        if [ "${_include_sim}" = true ]; then
            templateFile="$vanilla"
        else
            templateFile="$vanilla_noSIM"
        fi
    fi

    echo "done"
    echo ""

    # check if images are configured, and add default if not
    if [ "$enable_branding" = "true" ]; then
        if [ -z "${image_background_path}" ]; then
            image_background_path=$(func_find_file_by_name "background")
        fi

        if [ -z "${image_logo_path}" ]; then
            image_logo_path=$(func_find_file_by_name "logo")
        fi
    fi

    pathToDashboardFile=$(func_copy_file_and_replace_values ${templateFile})
    
    echo "Creating dashboard in the controller"
    sleep 3

    response=$(curl -s -X POST --user ${_user_credentials} ${url} -F file=@${pathToDashboardFile})

    expected_response='"success":true'

    func_check_http_response "\{$response}" $expected_response

    echo "*********************************************************************"
    echo "The dashboard was created successfully. "
    echo "Please check the $_controller_url controller "
    echo "The Dashboard name is '$_application_name:App Visibility Pane' "
    echo "*********************************************************************"

    echo ""
    sleep 3

    # save used uploaded files
    mkdir -p ./dashboards/uploaded

    cp -rf "./${tempFolder}" "./dashboards/uploaded/${_application_name}"."${dt}"

    func_cleanup

    echo ""
    echo ""
    echo "Checking Transaction configurantion instruction..."
    sleep 2

    #if [ "$configbt" = "configbt" ] || [ "$configbt" = "yes" ] || [ "$configbt" = "bt" ] || [ "$configbt" = "BT" ] || [ "$configbt" = "yes" ]; then
    if [ "${_configure_bt}" = true ]; then
        source ./configBT.sh "$_application_name"
    else
        echo ""
        echo ""
        echo "BT Configuration is set to false, not configuring BT"
    fi
    sleep 5

    echo ""
    echo ""
    echo "Done!"

#end of btconfigonly
fi