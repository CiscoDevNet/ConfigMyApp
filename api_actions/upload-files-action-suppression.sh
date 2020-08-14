#!/bin/bash

# 1. INPUT PARAMETERS
_controller_url=${1} # hostname + /controller
_user_credentials=${2} # ${username}:${password}

_application_name=${3}

# 2. FUNCTIONS
function func_check_http_response(){
    local http_message_body="$1"
    local string_success_response_contains="$2"
    if [[ "$http_message_body" =~ "$string_success_response_contains" ]]; then # contains
            echo "Success..."
    else
        echo "${dt} ERROR "{$http_message_body}"" >> error.log
        echo "ERROR $http_message_body"
        #exit 1
    fi
}

# 3. PREPARE REQUEST
dt=$(date '+%Y-%m-%d_%H-%M-%S')

_header="Content-Type: application/json; charset=utf8"

# application id
allApplications=$(curl -s --user ${_user_credentials} ${_controller_url}/rest/applications?output=JSON)

applicationObject=$(jq --arg appName "$_application_name" '.[] | select(.name == $appName)' <<<$allApplications)

if [ "$applicationObject" = "" ]; then
    func_check_http_status 404 "Application '"$_application_name"' not found. Aborting..."
fi

_application_id=$(jq '.id' <<< $applicationObject)
_resource_url="alerting/rest/v1/applications/${_application_id}/action-suppressions"

_action_suppression_files="./api_actions/actions/*.json"


for f in $_action_suppression_files; do
    echo "Processing $f action suppression file"

    _payload_path=$f

    # 4. SEND A CREATE REQUEST
    response=$(curl -s -X POST --user $_user_credentials $_controller_url/$_resource_url -H "${_header}" --data "@${_payload_path}" )

    # 5. CHECK RESULT
    expected_response='"id":' # returns id on success
    func_check_http_response "\{$response}" $expected_response

    # echo "response is: $response"

done
 
