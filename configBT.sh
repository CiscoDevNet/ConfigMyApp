#This script only works for non-production controller for mow
#Create a template for your BTs and rename the file to your <app_name>.xml
#for example ./configBT <app_name> <prod|dev|uat|test>

conf_file="config.json"
prod_controller=$(jq -r ' .prod_controller_details[].url' < ${conf_file})
prod_username=$(jq -r ' .prod_controller_details[].username' < ${conf_file})
prod_password=$(jq -r ' .prod_controller_details[].password' < ${conf_file})
#echo "Prod $prod_username >  $prod_controller >  $prod_password > $prod_serverVizAppID" 
dev_controller=$(jq -r ' .non_prod_controller_details[].url' < ${conf_file})
dev_username=$(jq -r ' .non_prod_controller_details[].username' < ${conf_file})
dev_password=$(jq -r ' .non_prod_controller_details[].password' < ${conf_file})

controller=${2}
app_name=${1}

echo "Creating BT rules in ${app_name} application in ${controller} controller please wait.. "  

echo ""


if [ "$controller" == "prod" ] || [ "$controller" == "production" ] || [ "$controller" == "PROD" ] || [ "$controller" == "PRODUCTION" ];  then
  hostname=${prod_controller}
  password=${prod_password}
  username=${prod_username}

 else
  hostname=${dev_controller}
  password=${dev_password}
  username=${dev_username}
fi

curl  -X POST --user ${username}:${password} ${hostname}/controller/transactiondetection/${app_name}/custom -F file=@${app_name}.xml

sleep 3

#TODO, get the response code and determine success or failure 
echo "Successfully Created Business transaction rules "  