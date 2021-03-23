#!/bin/bash

source ./modules/rbac/api_roles.sh 
source ./modules/rbac/api_users.sh
source ./modules/rbac/api_groups.sh

source ./modules/rbac/restui_auth.sh
source ./modules/rbac/restui_roles.sh
source ./modules/rbac/restui_saml.sh


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

# echo "____________"

# func_get_all_groups "${_controller_url}" "${_user_credentials}" "${_application_name}" "${_proxy_details}" "${_debug}"

# echo "____________"

# func_get_all_roles "${_controller_url}" "${_user_credentials}" "${_application_name}" "${_proxy_details}" "${_debug}"

# echo "____________"

# func_get_all_users "${_controller_url}" "${_user_credentials}" "${_application_name}" "${_proxy_details}" "${_debug}"

# echo "____________"

#func_get_user_by_id "${_controller_url}" "${_user_credentials}" "${_application_name}" "${_proxy_details}" "${_debug}" "10"

#echo "____________"

#func_create_group "${_controller_url}" "${_user_credentials}" "${_application_name}" "${_proxy_details}" "${_debug}" "API-CREATED-ME-3" "desc"

echo "____________"

#todo always request cookie and get token before restui calls (!)
_token_header=$(func_restui_get_cookie "${_controller_url}" "${_user_credentials}" "${_proxy_details}")

echo "============"

echo "TOKEN IS: ${_token_header}"

echo "____________"

#func_restui_get_roles  "${_controller_url}" "${_user_credentials}" "${_proxy_details}" "${_application_name}" "${_debug}" "${_token_header}"

# _role_name="test-me-from-bash"
# _role_description="test-me-desc"

# func_restui_create_role_with_default_view_and_view_edit_app_permissions "${_controller_url}" "${_user_credentials}" "${_proxy_details}" "${_application_name}" "${_debug}" "${_token_header}" "${_role_name}" "${_role_description}"

echo "____________"

_role_ids="28,16" #no space! roles have to be existing ones to be created
_saml_group_name="API-CREATED-ME"

func_update_saml_configuration "${_controller_url}" "${_user_credentials}" "${_proxy_details}" "${_debug}" "${_token_header}" "${_role_ids}" "${_saml_group_name}" 