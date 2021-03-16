#!/bin/bash

source ./modules/common/application.sh #func_get_application_id

function func_get_saml_configuration() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _proxy_details=${3} 

    local _debug=${4}

    local X_CSRF_TOKEN_HEADER=${5}

    _endpoint_url="/restui/accountAdmin/getSAMLConfiguration"
    _method="GET"

    response=$(curl -s -b cookie.appd -H "$X_CSRF_TOKEN_HEADER" -X ${_method} "${_controller_url}${_endpoint_url}" ${_proxy_details})

    echo "${response}"

}

function func_update_saml_configuration() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _proxy_details=${3} 

    local _debug=${4}

    local X_CSRF_TOKEN_HEADER=${5}

    local _role_ids=${6}
    local _saml_group_name=${7}

    _payload_header="Content-Type: application/json; charset=utf8"

    dt=$(date '+%Y-%m-%d_%H-%M-%S')

    _files_directory="./rbac/restui_saml_files"
    _uploaded_path="${_files_directory}/uploaded"
    _payload_path="${_uploaded_path}/payload-${dt}.json"

    #todo check if single integer or comma-separated IDs
    
    # get current configuration 
    _current_saml_config=$(func_get_saml_configuration "${_controller_url}" "${_user_credentials}" "${_proxy_details}" "${_debug}" "${X_CSRF_TOKEN_HEADER}")

    #echo ">>>> current config: $_current_saml_config"

    # add new group
    with_group=$(jq '.samlRoles += ["'"$_saml_group_name"'"]' <<< $_current_saml_config)

    with_group_and_roles=$(jq  --arg new "$_role_ids" '.accountRoles += ['[$_role_ids]']' <<< $with_group)

    # number of roles and groups count control?

    _endpoint_url="/restui/accountAdmin/updateSAMLConfiguration"
    _method="POST"

    response=$(curl -s -b cookie.appd -H "$X_CSRF_TOKEN_HEADER" -H "${_payload_header}" -X ${_method} -d "${with_group_and_roles}" "${_controller_url}${_endpoint_url}")
    
    echo "${response}" > ${_payload_path}
}


