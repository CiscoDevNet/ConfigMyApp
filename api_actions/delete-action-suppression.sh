#!/bin/bash

# 1. INPUT PARAMETERS
_controller_url=${1} # hostname + /controller
_user_credentials=${2} # ${username}:${password}

_action_suppression_name=${3}

_application_name=${4}

# 2. PREPARE REQUEST

# application id
allApplications=$(curl -s --user ${_user_credentials} ${_controller_url}/rest/applications?output=JSON)

applicationObject=$(jq --arg appName "$_application_name" '.[] | select(.name == $appName)' <<<$allApplications)

if [ "$applicationObject" = "" ]; then
    func_check_http_status 404 "Application '"$_application_name"' not found. Aborting..."
fi

application_id=$(jq '.id' <<< $applicationObject)

#  suppression id
actionSupressions=$(curl -s --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${application_id}/action-suppressions)

if [ "$actionSupressions" = "" ]; then
    func_check_http_status 404 "Action supression '"$_action_suppression_name"' not found. Aborting..."
fi

actionSupressionObject=$(jq --arg suppressionName "$_action_suppression_name" '.[] | select(.name == $suppressionName)' <<< $actionSupressions)

action_supression_id=$(jq '.id' <<< $actionSupressionObject)

# request url
_resource_url="alerting/rest/v1/applications/${application_id}/action-suppressions/${action_supression_id}"

# 3. SEND A DELETE REQUEST
echo "Deleting application supression action"
# response is always empty
response=$(curl -s -X DELETE --user $_user_credentials $_controller_url/$_resource_url)
