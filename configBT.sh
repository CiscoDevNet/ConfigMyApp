#This script only works for non-production controller for mow
#Create a template for your BTs and rename the file to your <app_name>.xml
#for example ./configBT <app_name>
dev_username="configmyapp@customer1-dev"
dev_password="pass"

dev_controller="https://customer1-dev.saas.appdynamics.com"

echo "Creating BT rules in ${1} application, please wait.. "  

echo ""

curl  -X POST --user ${dev_username}:${dev_password} ${dev_controller}/controller/transactiondetection/${1}/custom -F file=@${1}.xml

sleep 3

echo "Successfully Created Business transaction rules"  