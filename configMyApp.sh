#!/bin/bash

# ./configMyApp.sh inflation-qa 'CORP – SQL Server' qa

#./configMyApp.sh fusion-crosstrade-uat crosstrade-qa-cluster-db dev
#./configMyApp.sh fusion-crosstrade-uat no dev

#./configMyApp.sh fusion-crosstrade-prod none prod
#./configMyApp.sh fusion-equities-prod no prod
#./configMyApp.sh fusion-pot-prod no prod

#./configMyApp.sh fusion-platform-dev crosstrade-qa-cluster-db dev

# Change these params 

overwrite_health_rules="true"
prod_username="configmyapp@customer1"
dev_username="configmyapp@customer1-dev"

prod_password="pass"
dev_password="pass"

prod_controller="https://customer1.saas.appdynamics.com"
dev_controller="https://customer1-dev.saas.appdynamics.com"

prod_serverVizAppID="2384"
dev_serverVizAppID="57803"

# Do not change anything else beyond this point except you know what you're doing :) 
vanilla_noDB="CustomDashboard_noDB_vanilla.json"
vanilla="CustomDashboard_vanilla.json"
templateAppName="ChangeApplicationName"
templateDBName="ChangeDBName"
serverVizHealthRuleFile="ServerHealthRules.xml"
applicationHealthRule="ApplicationHealthRules.xml"

IOURLEncoder() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER) 
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

if [ "$1" != "" ]; then
    appName=$1
else
    read -p "Enter your business application name [ENTER]:  "  appName
fi


if [ "$appName" == "--help" ]; then
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
    echo  "*********************************************************************************************************************************************"
    exit 1
fi

echo "You entered '$appName' for application name"
echo ""
if [ "$2" != "" ]; then
    DBName=$2
else
    echo ""
    echo "Enter a name of a related Database Collector."
    read -p "Enter 'no' if the target app is not associated with a database [ENTER]:  "  DBName
fi

echo "You entered '$DBName' for Database collector name"
echo ""
if [ "$3" != "" ]; then
    controller=$3
else
    echo ""
    echo "What's your application environment?"
    read -p "Please enter one of prod,dev,uat,qa etc [ENTER]:  " controller
fi

echo "You entered '$controller' for application evironment"
echo ""

if [ "$4" != "" ]; then
    configbt=$4
else
    configbt="no"
fi

echo "You entered '$configbt' for transaction configuration"
echo ""

if [ "$appName" == "" ] || [ "$DBName" == "" ]; then 
    echo "You must define Application Name and Database Name, set DBName to no if you're not interested in DB monitoring"
    exit 1
fi

if [ "$controller" == "prod" ] || [ "$controller" == "production" ] || [ "$controller" == "PROD" ] || [ "$controller" == "PRODUCTION" ];  then
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

endpoint="/controller/CustomDashboardImportExportServlet"
url=${hostname}${endpoint}

echo "Import Dash URL $url"
echo ""
echo ""
echo "Creating Server Viz Health Rules..."
sleep 3

#ServerViz health rules 
sed -i.bak -e "s/${templateAppName}/${appName}/g" ${serverVizHealthRuleFile}
curl -X POST --user ${username}:${password} ${hostname}/controller/healthrules/${serverVizAppID}?overwrite=${overwrite_health_rules} -F file=@${serverVizHealthRuleFile}
sleep 4
#Application health rules 
echo "Creating ${appName} Health Rules..."
sleep 4
#URL Encode AppDName 
echo "URL ecoding App Name"
sleep 1
encodeAppName=$(IOURLEncoder $appName)
echo "Encoded AppName is :  $encodeAppName"
echo ""
echo ""
curl -X POST --user ${username}:${password} ${hostname}/controller/healthrules/$encodeAppName?overwrite=${overwrite_health_rules} -F file=@${applicationHealthRule}
sleep 1
echo ""
echo ""
echo "Processing Dashboard Template."
sleep 3
echo ""
echo ""
#Dashboard
if [ "$DBName" == "NO" ] || [ "$DBName" == "no" ] || [ "$DBName" == "none" ] ; then
    #remove the DB section from the JSON file 
    echo "Applying Database settings..."
    sleep 1
    templateFile="DashboardTemplate_noDB.json"
    #sed -i.DBbak -e '885,948d;1201,1242d' ${templateFile} 
 else
    templateFile="DashboardTemplate.json"

fi

dt=$(date '+%Y-%m-%d_%H-%M-%S')
sed -i -e "s/${templateAppName}/${appName}/g; s/${templateDBName}/${DBName}/g" ${templateFile}

response=$(curl -X POST --user ${username}:${password} ${url} -F file=@${templateFile})

if [[ "$response" == *"$appName"* ]]; then
    echo  "*********************************************************************"
    echo      "The dashboard was created successfully. "
    echo       "Please check the $hostname controller "
    echo       "The Dashboard name is '$appName:App Visibility Pane' "
    echo  "*********************************************************************"
 
else
   echo "Error occured in creating dashboard. See details below:"
   echo $response
fi 

echo ""
echo ""
sleep 3
echo "Restoring vanilla template files... please wait.."
sleep 5
#restore original template files for next use
mv ${serverVizHealthRuleFile}.bak ${serverVizHealthRuleFile}
if [ "$DBName" == "NO" ] || [ "$DBName" == "no" ] || [ "$DBName" == "none" ] ; then
  cp $templateFile $appName.$dt.json
  cp $vanilla_noDB $templateFile
 else
   cp $templateFile $appName.$dt.json
   cp $vanilla $templateFile
fi
echo ""
echo ""
echo "Checking Transaction configurantion instruction..."
sleep 2

if [ "$configbt" == "configbt" ] || [ "$configbt" == "yes" ] || [ "$configbt" == "bt" ]; then
  FILE=$appName.xml
    if [ -f "$FILE" ]; then
        echo "$FILE exist"
        btendpoint="/controller/transactiondetection/${appName}/custom"
        response=$(curl -X POST --user ${username}:${password} ${hostname}${btendpoint} -F file=@${FILE})
        if [[ "$response" == *"HTTP/1.1 200 OK"* ]]; then
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

