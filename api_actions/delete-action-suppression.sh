#!/bin/bash

# 1. INPUT PARAMETERS
_controller_url=${1} # hostname + /controller
_user_credentials=${2} # ${username}:${password}

_proxy_details=${3} 

_action_suppression_name=${4}

_application_name=${5}

# 2. FUNCTIONS
dt=$(date '+%Y-%m-%d_%H-%M-%S')

function func_check_http_status() {
    local http_code=$1
    local message_on_failure=$2
    if [[ $http_code -lt 200 ]] || [[ $http_code -gt 299 ]]; then
        echo "${dt} ERROR "{$http_code: $message_on_failure}"" >> error.log
        echo "ERROR $http_code: $message_on_failure"
        exit 1
    fi
}

# 3. PREPARE REQUEST

# 3.1 Get application id
allApplications=$(curl -s --user ${_user_credentials} ${_controller_url}/rest/applications?output=JSON ${_proxy_details})

applicationObject=$(jq --arg appName "$_application_name" '.[] | select(.name == $appName)' <<<$allApplications)

if [ "$applicationObject" = "" ]; then
    func_check_http_status 404 "Application '"$_application_name"' not found. Aborting..."
fi

application_id=$(jq '.id' <<< $applicationObject)

# 3.2 Get suppression id
actionSupressions=$(curl -s --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${application_id}/action-suppressions ${_proxy_details})

actionSupressionObject=$(jq --arg suppressionName "$_action_suppression_name" '.[] | select(.name == $suppressionName)' <<< $actionSupressions)

if [ "$actionSupressionObject" = "" ]; then
    func_check_http_status 404 "Action supression '"$_action_suppression_name"' not found. Aborting..."
fi

action_supression_id=$(jq '.id' <<< $actionSupressionObject)

# 3.3 Set request url
_resource_url="alerting/rest/v1/applications/${application_id}/action-suppressions/${action_supression_id}"

# 4. SEND A DELETE REQUEST
echo "Deleting '"$_action_suppression_name"' application supression action..."
# response is always empty
response=$(curl -s -X DELETE --user $_user_credentials $_controller_url/$_resource_url ${_proxy_details})

echo "Done."
