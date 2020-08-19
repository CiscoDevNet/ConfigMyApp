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

# make a directory if not exist
mkdir -p ./api_actions/actions
mkdir -p ./api_actions/uploaded
_action_suppression_files="./api_actions/actions/*.json"

for f in $_action_suppression_files; do
    
    # Check if folder contains files
    [ -f "$f" ] || func_check_http_status 404 "No files found that match pattern: '"$_action_suppression_files"'. Aborting..."

    echo "Processing '"$f"' action suppression file"

    _payload_path=$f

    # 4. SEND A CREATE REQUEST
    response=$(curl -s -X POST --user $_user_credentials $_controller_url/$_resource_url -H "${_header}" --data "@${_payload_path}" )

    # 5. CHECK RESULT
    expected_response='"id":' # returns id on success
    func_check_http_response "\{$response}" $expected_response

    fileName="$(basename -- $f)"
    cp -rf "$_payload_path" "./api_actions/uploaded/${fileName}.${dt}"

    # echo "response is: $response"

done
 
