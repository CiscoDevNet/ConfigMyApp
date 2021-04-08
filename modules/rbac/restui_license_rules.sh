#!/bin/bash

source ./modules/common/http_check.sh # func_check_http_status
source ./modules/common/logging.sh # func_log_error_to_file


function func_restui_get_license_rules() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _proxy_details=${3} 

    local _application_name=${4}
    local _debug=${5}

    local X_CSRF_TOKEN_HEADER=${6}

    if [[ _debug = true ]]; then echo ">> func_restui_get_roles"; fi

    _endpoint_url="/restui/licenseRule/getAllRulesSummary"
    _method="GET"

    licenseRulesSummary=$(curl -v -s -b cookie.appd -H "$X_CSRF_TOKEN_HEADER" -X ${_method} "${_controller_url}${_endpoint_url}")
    
    echo "${licenseRulesSummary}"
}

function func_restui_create_license_rules() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _proxy_details=${3} 

    local _application_name=${4}
    local _debug=${5}

    local X_CSRF_TOKEN_HEADER=${6}

    #local _rule_name=${7}

    echo "||Creating license key rule '${_rule_name}'..."

    #if [[ _debug = true ]]; then echo ">> func_restui_create_role_with_default_view_and_view_edit_app_permissions"; fi

    dt=$(date '+%Y-%m-%d_%H-%M-%S')

    _rule_name_placeholder="<license-rule-name-goes-here>"
    _rule_id_placeholder="<license-rule-id-goes-here>"
    _rule_key_placeholder="<license-rule-key-goes-here>"

    _files_directory="./rbac/restui_license_rules_files"

    _uploaded_path="${_files_directory}/uploaded"
    _payload_path="${_uploaded_path}/payload-${dt}.json"

    _payload_header="Content-Type: application/json; charset=utf8"

    _name_prefix="cma"

    # prepare payload
    for _json_file in $_files_directory/*.json; do

        _file_name="$(basename -- $_json_file)"

        # Check if folder contains files
        [ -f "$_json_file" ] || func_check_http_status 404 "No files found in directory: '"$_files_directory"'. Aborting..."

        _tmp_updated_file_path="${_uploaded_path}/tmp-${_file_name}-${dt}"

        # generate for each file found in directory
        _rbac_rnd=$((1 + $RANDOM % 1000))
        _rule_name="${_name_prefix}_rule_${_rbac_rnd}"
        echo "INFO|License rule name created '${_rule_name}'"
        _rule_id=$(uuidgen)
        _rule_key=$(uuidgen)
        
        echo -e "Processing '${_file_name}' file, creating license rule '${_rule_name}'."

        # replacing license rule name 
        if grep -q $_rule_name_placeholder ${_json_file}; then
            sed -e "s/${_rule_name_placeholder}/${_rule_name}/g" "${_json_file}" > "${_tmp_updated_file_path}"
        else
            echo -e "WARNING Placeholder value '$_rule_name_placeholder' not found in '${_file_name}'. Value not replaced."
            copying=$(cp "${_json_file}" "${_tmp_updated_file_path}")
        fi

        # replace rule id and key
        sed -e "s/${_rule_id_placeholder}/${_rule_id}/g" -e "s/${_rule_key_placeholder}/${_rule_key}/g" "${_tmp_updated_file_path}" > "${_payload_path}"

        _endpoint_url="/restui/licenseRule/create"
        _method="POST"

        response=$(curl -s -b cookie.appd -H "$X_CSRF_TOKEN_HEADER" -H "${_payload_header}" -X ${_method} --data "@${_payload_path}" "${_controller_url}${_endpoint_url}")

        # remove temporary files, save only final payload backup
        rm ${_uploaded_path}/tmp-*

        echo "${response}"

    done 

    

}


