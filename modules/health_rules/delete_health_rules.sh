#!/bin/bash

# 1. INPUT PARAMETERS
_controller_url=${1}   # hostname + /controller
_user_credentials=${2} # ${username}:${password}

_application_name=${3}
_proxy_details=${4}

_health_rules_delete=${5}

# 2. FUNCTIONS
function func_check_http_status() {
    local http_code=$1
    local message_on_failure=$2
    #echo "HTTP status code: $http_code"
    if [[ $http_code -lt 200 ]] || [[ $http_code -gt 299 ]]; then
        echo "${dt} ERROR "{$http_code: $message_on_failure}"" >> error.log
        echo "$http_code: $message_on_failure"
        func_cleanup
        exit 1
    fi
}

function func_delete_health_rules(){
    local appId=$1
    local healthRulesToDelete="$2"

     # get all current health rules for application
    allHealthRules=$(curl -s --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${appId}/health-rules ${_proxy_details})

    hrName=${healthRulesToDelete}
    #for hrName in "${healthRulesToDelete[@]}"; do 

    echo "Deleting '$hrName' health rule..."

    # get health rule id (if exists)
    healthRuleId=$(jq --arg hrName "$hrName" '.[] | select(.name == $hrName) | .id' <<<$allHealthRules)

    # create new if health rule id does not exist
    if [ ! -z "${healthRuleId// }" ]; then
        httpCode=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${appId}/health-rules/${healthRuleId} ${_proxy_details})
        func_check_http_status $httpCode "Error occured while deleting health rule '${hrName}'."
        echo "done"
    else 
        echo "Health rule '$hrName' not found. No action performed."
    fi
        
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
func_delete_health_rules $appId "${_health_rules_delete}"