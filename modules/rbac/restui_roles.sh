#!/bin/bash

function func_restui_get_roles() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _proxy_details=${3} 

    local _application_name=${4}
    local _debug=${5}

    local X_CSRF_TOKEN_HEADER=${6}

    _endpoint_url="/restui/accountRoleAdministrationUiService/accountRoleSummaries"
    _method="GET"

    curl -i -v -s -b cookie.appd -H "$X_CSRF_TOKEN_HEADER" -X ${_method} "${_controller_url}${_endpoint_url}"

}

function func_restui_create_role_with_default_view_and_view_edit_app_permissions() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _proxy_details=${3} 

    local _application_name=${4}
    local _debug=${5}

    local X_CSRF_TOKEN_HEADER=${6}

    _role_name="test-me"
    _role_description="test-me-desc"
    _application_name_placeholder="<app-id-goes-here>"
    _files_directory="./modules/rbac/restui_role_files"

    # prepare payload
    for _json_file in $_files_directory/*.json; do

        _file_name="$(basename -- $_json_file)"
        
        echo -e "Processing ${_file_name} json file. Using the '${_application_name}' application. \n"

        if grep -q $_application_name_placeholder ${_json_file}; then
            echo "true"
            sed -i -e "s/${_application_name_placeholder}/${_application_name}/g" "${_json_file}"
        else
            echo "false"
            echo -e "WARNING Placeholder value '$_application_name_placeholder' not found in json file provided. "
        fi

    done

    _endpoint_url="/restui/accountRoleAdministrationUiService/accountRoles/create"
    _method="POST"

    curl -i -v -s -b cookie.appd -H "$X_CSRF_TOKEN_HEADER" -X ${_method} "${_controller_url}${_endpoint_url}"

}


