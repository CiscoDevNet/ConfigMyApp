#!/bin/bash

# 1. INPUT PARAMETERS
_controller_url=${1}   # hostname + /controller
_user_credentials=${2} # ${username}:${password}

_application_name=${3}
_proxy_details=${4}

_custom_dash_dir="./custom_dashboards" #I might move this into dashboard folder.. let see..
_temp_dash_dir="$_custom_dash_dir/temp"
templateAppName="ChangeApplicationName"


function func_check_http_response() {
    local http_message_body="$1"
    local string_success_response_contains="$2"
    if [[ "$http_message_body" =~ "$string_success_response_contains" ]]; then # contains
        echo "Success..."
    else
        echo "${dt} ERROR "{$http_message_body}"" >>error.log
        echo "ERROR $http_message_body"
        #exit 1
    fi
}

# application id
allApplications=$(curl -s --user ${_user_credentials} ${_controller_url}/rest/applications?output=JSON)

applicationObject=$(jq --arg appName "$_application_name" '.[] | select(.name == $appName)' <<<$allApplications)

if [ "$applicationObject" = "" ]; then
    func_check_http_response 404 "Application '"$_application_name"' not found. Aborting..."
fi

_application_id=$(jq '.id' <<<$applicationObject)

_dasboard_API_endpoint="/CustomDashboardImportExportServlet"

_vanilla_files="./custom_dashboards/*.json"

mkdir -p "$_temp_dash_dir" && cp -r "$_custom_dash_dir/*.json" "$_temp_dash_dir"

sed -i -e "s/${templateAppName}/${_application_name}/g" "$_temp_dash_dir/*.json"

for dashFile in $_temp_dash_dir; do
    echo "Processing $dashFile dashboard template"

    response=$(curl -s -X POST --user ${_user_credentials} ${_controller_url}/${_dasboard_API_endpoint} -F file=@${dashFile} ${_proxy_details})

    expected_response='"success":true'

    func_check_http_response "\{$response}" $expected_response

    echo "*********************************************************************"
    echo "The $dashFile dashboard was created successfully. "
    echo "Please check the $_controller_url controller "
    echo "*********************************************************************"

    echo ""
    sleep 1

    # save used uploaded files
    mkdir -p "${_custom_dash_dir}/uploaded"

    cp -rf "./${_temp_dash_dir}/${dashFile}" "${_custom_dash_dir}/uploaded/${_application_name}"-"${dashFile}"

    #clean up - one at a time
    rm -rf "./${_temp_dash_dir}/${dashFile}"

done
