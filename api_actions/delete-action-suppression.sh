#!/bin/bash

# 1. INPUT PARAMETERS
_controller_url=${1} # hostname + /controller
_user_credentials=${2} # ${username}:${password}

_action_suppression_name=${3}

_application_name=${4}

# 2. FUNCTIONS
function func_check_http_response(){
    local http_message_body="$1"
    local string_success_response_contains="$2"
    if [[ "$http_message_body" =~ "$string_success_response_contains" ]]; then # contains
            echo "Success..."
        else
            echo "${dt} ERROR "{$http_message_body}"" >> error.log
            echo "ERROR $http_message_body"
            exit 1
        fi
}

# 3. PREPARE REQUEST

# application id
allApplications=$(curl -s --user ${_user_credentials} ${_controller_url}/rest/applications?output=JSON)

applicationObject=$(jq --arg appName "$_application_name" '.[] | select(.name == $appName)' <<<$allApplications)

if [ "$applicationObject" = "" ]; then
    func_check_http_status 404 "Application '"$_application_name"' not found. Aborting..."
fi

application_id=$(jq '.id' <<< $applicationObject)

# action id
actionSupression=$(curl -s --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${application_id}/action-suppressions?name=${_action_suppression_name})

if [ "$actionSupression" = "" ]; then
    func_check_http_status 404 "Action supression '"$_action_suppression_name"' not found. Aborting..."
fi

action_supression_id=$(jq '.id' <<< $actionSupression)

_resource_url="alerting/rest/v1/applications/${application_id}/action-suppressions/${action_supression_id}"

# 4. SEND A CREATE REQUEST
echo "Uploading application supression action"
response=$(curl -s -X DELETE --user $_user_credentials $_controller_url/$_resource_url)

# 5. CHECK RESULT
expected_response='"id":' # returns id on success
func_check_http_response "\{$response}" $expected_response
 
echo "response is: $response"
