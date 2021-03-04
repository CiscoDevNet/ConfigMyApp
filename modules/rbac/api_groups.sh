#!/bin/bash

source ./modules/common/http_check.sh # func_check_http_status
source ./modules/common/application.sh # func_get_application_id

_endpoint_url="/api/rbac/v1/groups"

function func_get_all_groups() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _application_name=${3}
    local _proxy_details=${4} 
    local _debug=${6}

    _method="GET"
    if [ $_debug = true ]; then _output="-v"; else _output="-s"; fi

    # Get all groups
    groups=$(curl ${_output} -X ${_method} --user ${_user_credentials} ${_controller_url}{$_endpoint_url} ${_proxy_details})

    echo "${groups}"

}

function func_group_id_by_name() {
    local _controller_url=${1} # hostname + /controller
    local _user_credentials=${2} # ${username}:${password}
    local _application_name=${3}
    local _proxy_details=${4} 
    local _debug=${6}

    local _group_name=${7}

    _method="GET"
    _endpoint_url="${_endpoint_url}/name/${_group_name}"
    if [ $_debug = true ]; then _output="-v"; else _output="-s"; fi

    # Get group by name
    group=$(curl ${_output} -X ${_method} --user ${_user_credentials} ${_controller_url}{$_endpoint_url} ${_proxy_details})

    group_id=$(jq '.[] | select(.id)' <<<$group)

    if [ "$group_id" = "" ]; then
        func_check_http_status 404 "Group name ${_group_name} not found."
    fi

    echo "${group_id}"

}

