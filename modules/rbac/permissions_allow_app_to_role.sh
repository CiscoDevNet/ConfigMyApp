#!/bin/bash

source ./modules/rbac/api_roles.sh 
source ./modules/rbac/api_users.sh
source ./modules/rbac/api_groups.sh

_controller_url=${1} # hostname + /controller
_user_credentials=${2} # ${username}:${password}
_proxy_details=${3} 
_application_name=${4}
_debug=${5}

echo "_controller_url ${_controller_url}"
echo "_user_credentials ${_user_credentials}"
echo "_proxy_details ${_proxy_details}"
echo "_application_name ${_application_name}"
echo "_debug ${_debug}"

echo "____________"

func_get_all_groups "${_controller_url}" "${_user_credentials}" "${_application_name}" "${_proxy_details}" "${_debug}"

echo "____________"

func_get_all_roles "${_controller_url}" "${_user_credentials}" "${_application_name}" "${_proxy_details}" "${_debug}"

echo "____________"

func_get_all_users "${_controller_url}" "${_user_credentials}" "${_application_name}" "${_proxy_details}" "${_debug}"

echo "____________"

#func_get_user_by_id "${_controller_url}" "${_user_credentials}" "${_application_name}" "${_proxy_details}" "${_debug}" "10"

#echo "____________"

#func_create_group "${_controller_url}" "${_user_credentials}" "${_application_name}" "${_proxy_details}" "${_debug}" "API-CREATED-ME-3" "desc"
