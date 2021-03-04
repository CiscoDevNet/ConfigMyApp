#!/bin/bash

source ./modules/common/http_check.sh # func_check_http_status
source ./modules/common/application.sh # func_get_application_id

_endpoint_url="/api/rbac/v1/users"

function func_get_all_users() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _application_name=${3}
    local _proxy_details=${4} 
    local _debug=${6}

    # Get all applications
    allUsers=$(curl -s --user ${_user_credentials} ${_controller_url}{$_endpoint_url} ${_proxy_details})

    echo "${allUsers}"

}

