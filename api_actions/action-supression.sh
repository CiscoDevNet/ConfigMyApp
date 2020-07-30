#!/bin/bash

_controller_url=${1} # hostname + /controller
_user_credentials=${2} # ${username}:${password}

_action_supression_start=${3}
_action_supression_duration=${4} 

_application_name=${5}

payload_path="./api_actions/uploaded/action-supression-payload.json"
template_path="./api_actions/action-supression-payload.json"
_action_supression_name="CMA_supression_action"

dt=$(date '+%Y-%m-%d_%H-%M-%S')

# prepare request

# _action_supression_end=$(date --date='$_action_supression_duration minutes' + %FT%T+0000)
# for Mac, TODO test on linux
_action_supression_end=$(date -v+${_action_supression_duration}M +%FT%T+0000) 

header="Content-Type: application/json; charset=utf8"

# populate the payload template
sed -e "s/_action_supression_name/${_action_supression_name}/g" -e "s/_action_supression_start/${_action_supression_start}/g" -e "s/_action_supression_end/${_action_supression_end}/g" "${template_path}" > "${payload_path}"

# application id
allApplications=$(curl -s --user ${_user_credentials} ${_controller_url}/rest/applications?output=JSON)

applicationObject=$(jq --arg appName "$_application_name" '.[] | select(.name == $appName)' <<<$allApplications)

if [ "$applicationObject" = "" ]; then
    func_check_http_status 404 "Application '"$_application_name"' not found. Aborting..."
fi

application_id=$(jq '.id' <<< $applicationObject)

resource_url="alerting/rest/v1/applications/${application_id}/action-suppressions"

# for test
echo "curl -X POST --user $_user_credentials $_controller_url/$resource_url -H "${header}" --data =@${payload_path} "


result=$(curl -v -X POST --user $_user_credentials $_controller_url/$resource_url -H "${header}" --data "@${payload_path}" )

echo "RESULT: $result"

#cp -rf "./${tempFolder}" "./dashboards/uploaded/${_application_name}"."${dt}"

exit 1