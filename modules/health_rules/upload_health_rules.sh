#!/bin/bash

# 1. INPUT PARAMETERS
_controller_url=${1}   # hostname + /controller
_user_credentials=${2} # ${username}:${password}

_application_name=${3}
_proxy_details=${4}
_debug=${5}

_health_rules_overwrite=${6}
_include_sim=${7}

#init HR templates
serverVizHealthRuleFile="./health_rules/ServerVisibility/*.json"
applicationHealthRule="./health_rules/Application/*.json"

# 2. FUNCTIONS
function func_check_http_status() {
    local http_code=$1
    local message_on_failure=$2
    #echo "HTTP status code: $http_code"
    if [[ $http_code -lt 200 ]] || [[ $http_code -gt 299 ]]; then
        echo "${dt} ERROR "{$http_code: $message_on_failure}"" >> error.log
        echo "$http_code: $message_on_failure"
        exit 1
    fi
}

function func_import_health_rules(){
    local appId=$1
    local folderPath=$2

     # get all current health rules for application
    allHealthRules=$(curl -s --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${appId}/health-rules ${_proxy_details})

    for f in $folderPath; do 
        echo "Processing $f health rule template"
        # get health rule name from json file
        healthRuleName=$(jq -r  '.name' <$f)
        # use it to get health rule id (if exists)
        healthRuleId=$(jq --arg hrName "$healthRuleName" '.[] | select(.name == $hrName) | .id' <<<$allHealthRules)

        # create new if health rule id does not exist
        if [ "${healthRuleId}" == "" ]; then
            httpCode=$(curl -s -o /dev/null -w "%{http_code}" -X POST --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${appId}/health-rules --header "Content-Type: application/json" --data "@${f}" ${_proxy_details})
            func_check_http_status $httpCode "Error occured while importing health rule ${healthRuleName}."
        # overwrite existing health rule only if flag is true
        elif [ "${_health_rules_overwrite}" = true ]; then
            httpCode=$(curl -s -o /dev/null -w "%{http_code}" -X PUT --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${appId}/health-rules/${healthRuleId} --header "Content-Type: application/json" --data "@${f}" ${_proxy_details})
            func_check_http_status $httpCode "Error occured while importing server rule ${healthRuleName}."
        fi

    done
}

# 3. PREPARE 
# check if App exist
allApplications=$(curl -s --user ${_user_credentials} ${_controller_url}/rest/applications?output=JSON $_proxy_details)

applicationObject=$(jq --arg appName "$_application_name" '.[] | select(.name == $appName)' <<<$allApplications)

if [ "$applicationObject" = "" ]; then
    func_check_http_status 404 "Application '"$_application_name"' not found. Aborting..."
fi

appId=$(jq '.id' <<<$applicationObject)

#All conditions met..

# 4. EXECUTE 

# Server Visibility health rules
if [ "${_include_sim}" = true ]; then
    echo "Creating Server Visibility Health Rules...Please wait"
    echo ""

    func_import_health_rules $appId "${serverVizHealthRuleFile}"
fi

# Application health rules
echo ""
echo "Creating ${_application_name} Health Rules..."
sleep 1

func_import_health_rules $appId "${applicationHealthRule}"




