#!/bin/bash

[[ "$(command -v jq)" ]] || {
    echo "jq is not installed, download it from - https://stedolan.github.io/jq/download/ and try again after installing it. Aborting..." 1>&2
    sleep 5
    exit 1
}

[[ "$(command -v base64)" ]] || {
    echo "base64 is not installed. Please ensure that you have 'base64' installed on this machine. Aborting..." 1>&2
    sleep 5
    exit 1
}

[[ "$(command -v awk)" ]] || {
    echo "awk is not installed, ConfigMyApp requires awk to be installed. Aborting..." 1>&2
    sleep 5
    exit 1
}


# Do not change anything else beyond this point except you know what you're doing :)

#init Dashboard templates
vanilla_noDB="./dashboards/CustomDashboard_noDB_vanilla.json"
vanilla="./dashboards/CustomDashboard_vanilla.json"

vanilla_noSIM="./dashboards/CustomDashboard_noSIM_vanilla.json"
vanilla_noDB_noSIM="./dashboards/CustomDashboard_noDB_noSIM_vanilla.json"

#init HR templates
serverVizHealthRuleFile="./healthrules/ServerVisibility/*.json"
applicationHealthRule="./healthrules/Application/*.json"

#init template placeholder
templateAppName="ChangeApplicationName"
templateDBName="ChangeDBName"
templateBackgroundImageName="ChangeImageUrlBackground"
templatLogoImageName="ChangeImageUrlLogo"

endpoint="/CustomDashboardImportExportServlet"

tempFolder="temp"
bt_folder="./business_transactions"

dt=$(date '+%Y-%m-%d_%H-%M-%S')

# echo "This Self Service Config tool configures application, server and business transaction health rules."

### START GETTING INPUT ARGUMENTS ###
_controller_url=${1} # hostname + /controller
_user_credentials=${2} # ${username}:${password}

_proxy_details=${3} 

_application_name=${4}
_include_database=${5} 
_database_name=${6}
_include_sim=${7}
_configure_bt=${8} 
_overwrite_health_rules=${9} 
_bt_only=${10}

_enable_branding=${11}
_image_logo_path=${12}
_image_background_path=${13}

### END GETTING INPUT ARGUMENTS ###

### START FUNCTIONS ###
IOURLEncoder() {
    local string="${1}"
    local strlen=${#string}
    local encoded=""
    local pos c o

    for ((pos = 0; pos < strlen; pos++)); do
        c=${string:$pos:1}
        case "$c" in
        [-_.~a-zA-Z0-9]) o="${c}" ;;
        *) printf -v o '%%%02x' "'$c" ;;
        esac
        encoded+="${o}"
    done
    echo "${encoded}"  # You can either set a return variable (FASTER)
    REPLY="${encoded}" #+or echo the result (EASIER)... or both... :p
}

function encode_image() {
    local image_path=$1

    $(chmod 775 $image_path)

    #image_extension="$(file -b $image_path | awk '{print $1}')"

    image_extension=$(echo "branding/logo.png" | awk -F . '{print $NF}' | awk '{print toupper($0)}')

    if [ $(is_image_valid $image_extension) = "False" ]; then
        echo "Image extension '$image_extension' of an '$image_path' not supported."
        exit 1
    fi

    #echo "Image extension '$image_extension' of '$image_path' ....."
    local image_prefix="data:image/png;base64,"
    echo | base64 -w0 >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        # GNU coreutils base64, '-w' supported
        local encoded_image="$(base64 -w 0 $image_path)"
        #local encoded_image="$(openssl base64 -A -in $image_path)"
    else
        # MacOS Openssl base64, no wrapping by default
        local encoded_image="$(base64 $image_path)"
    fi

    echo "${image_prefix} ${encoded_image}"
}

function is_image_valid() {
    declare -a image_extension_collection=("JPG" "JPEG" "PNG")

    local image_extension=$1

    if [[ ${image_extension_collection[$image_extension]} ]]; then echo "True"; else "False"; fi
}

function func_check_http_status() {
    local http_code=$1
    local message_on_failure=$2
    #echo "HTTP status code: $http_code"
    if [[ $http_code -lt 200 ]] || [[ $http_code -gt 299 ]]; then
        echo $message_on_failure
        func_cleanup
        exit 1
    fi
}

function func_check_http_response(){
    local http_message_body="$1"
    local string_success_response_contains="$2"
    if [[ "$http_message_body" =~ "$string_success_response_contains" ]]; then # contains
            echo "*********************************************************************"
            echo "Success"
            echo "*********************************************************************"
        else
            echo "${dt} ERROR "{$http_message_body}"" >> error.log
            echo "ERROR $http_message_body"
            func_cleanup
            exit 1
        fi
}

function func_find_file_by_name() {
    local imgName=$1

    result=$(find ./branding -name "*${imgName}*.[png|jpg|jpeg]*" | head -n 1)

    echo $result
}

function func_copy_file_and_replace_values() {
    local filePath=$1

    # make a temp file
    fileName="$(basename -- $filePath)"
    mkdir -p "$tempFolder" && cp -r $filePath ./$tempFolder/$fileName

    if [ "$_enable_branding" = "true" ]; then

        encodedBackgroundImageUrl="$(encode_image $_image_background_path)"
        encodedLogoImageUrl="$(encode_image $_image_logo_path)"

        echo "\"$encodedBackgroundImageUrl\"" >"${tempFolder}/backgroundImage.txt"
        echo "\"$encodedLogoImageUrl\"" >"${tempFolder}/logoImage.txt"

        # replace background picture
        sed -i.bkp -e "/${templateBackgroundImageName}/r ./${tempFolder}/backgroundImage.txt" -e "/${templateBackgroundImageName}/d" "${tempFolder}/${fileName}"

        # replace logo
        sed -i.bkp -e "/${templatLogoImageName}/r ./${tempFolder}/logoImage.txt" -e "/${templatLogoImageName}/d" "${tempFolder}/${fileName}"
    fi

    # replace application and database name
    sed -i.original -e "s/${templateAppName}/${_application_name}/g; s/${templateDBName}/${_database_name}/g" "${tempFolder}/${fileName}"

    # return full file path
    echo "${tempFolder}/${fileName}"
}

function func_cleanup() {
    # remove all from temp folder
    rm -rf $tempFolder
}

function func_import_health_rules(){
    local appId=$1
    local folderPath=$2

     # get all current health rules for application
    allHealthRules=$(curl -s --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${appId}/health-rules ${_proxy_details})

    for f in $folderPath; do 

        # get health rule name from json file
        healthRuleName=$(jq -r  '.name' <$f)
        # use it to get health rule id (if exists)
        healthRuleId=$(jq --arg hrName "$healthRuleName" '.[] | select(.name == $hrName) | .id' <<<$allHealthRules)

        # create new if health rule id does not exist
        if [ "${healthRuleId}" == "" ]; then
            httpCode=$(curl -s -o /dev/null -w "%{http_code}" -X POST --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${appId}/health-rules --header "Content-Type: application/json" --data "@${f}" ${_proxy_details})
            func_check_http_status $httpCode "Error occured while importing server health rules."
        # overwrite existing health rule only if flag is true
        elif [ "${_overwrite_health_rules}" = true ]; then
            httpCode=$(curl -s -o /dev/null -w "%{http_code}" -X PUT --user ${_user_credentials} ${_controller_url}/alerting/rest/v1/applications/${appId}/health-rules/${healthRuleId} --header "Content-Type: application/json" --data "@${f}" ${_proxy_details})
            func_check_http_status $httpCode "Error occured while importing server health rules."
        fi

    done
}

### END FUNCTIONS ###

url=${_controller_url}${endpoint}

echo ""

# Check if application exists
echo "Checking if ${_application_name} business application exist in ${_controller_url}..."
echo ""
sleep 1

allApplications=$(curl -s --user ${_user_credentials} ${_controller_url}/rest/applications?output=JSON ${_proxy_details})

applicationObject=$(jq --arg appName "$_application_name" '.[] | select(.name == $appName)' <<<$allApplications)

if [ "$applicationObject" = "" ]; then
    func_check_http_status 404 "Application '"$_application_name"' not found. Aborting..."
fi

appId=$(jq '.id' <<<$applicationObject)

echo "Found ${_application_name} business application"
echo ""

if [ "${_bt_only}" = true ]; then
    echo ""
    echo "You entered $_bt_only. This instruction will ONLY configure business transaction in $_application_name"
    echo "Application health rules, SIM health rules, dashboard, etc will not be created..."
    echo ""
    echo "Please wait while we process your Business transaction configuration settings from the JSON file"
    echo ""
    sleep 1
    source ./configBT.sh "$_application_name" "$_user_credentials" "$_controller_url"
else
    # proceed as normal

    # Server Visibility health rules
    if [ "${_include_sim}" = true ]; then
        echo "Creating Server Visibility Health Rules...Please wait"
        echo ""

        func_import_health_rules $appId "${serverVizHealthRuleFile}"
    fi

    # Application health rules
    echo ""
    echo "Creating ${_application_name} Health Rules..."
    sleep 1

    func_import_health_rules $appId "${applicationHealthRule}"

    echo ""
    sleep 1
    echo "done"

    echo ""
    echo "Processing Dashboard Template."
    sleep 1
    echo ""

    # Dashboard
    echo "Applying Database and SIM settings to the dashboard template..."
    sleep 1
    if [ "${_include_database}" = false ]; then

        if [ "${_include_database}" = true ]; then
            templateFile="$vanilla_noDB"
        else
            templateFile="$vanilla_noDB_noSIM"
        fi
    else
        if [ "${_include_sim}" = true ]; then
            templateFile="$vanilla"
        else
            templateFile="$vanilla_noSIM"
        fi
    fi

    echo "done"
    echo ""

    # check if images are configured, and add default if not
    if [ "$_enable_branding" = "true" ]; then
        if [ -z "${_image_background_path}" ]; then
            _image_background_path=$(func_find_file_by_name "background")
        fi

        if [ -z "${_image_logo_path}" ]; then
            _image_logo_path=$(func_find_file_by_name "logo")
        fi
    fi

    pathToDashboardFile=$(func_copy_file_and_replace_values ${templateFile})
    
    echo "Creating dashboard in the controller"
    sleep 1

    response=$(curl -s -X POST --user ${_user_credentials} ${url} -F file=@${pathToDashboardFile})

    expected_response='"success":true'

    func_check_http_response "\{$response}" $expected_response

    echo "*********************************************************************"
    echo "The dashboard was created successfully. "
    echo "Please check the $_controller_url controller "
    echo "The Dashboard name is '$_application_name:App Visibility Pane' "
    echo "*********************************************************************"

    echo ""
    sleep 1

    # save used uploaded files
    mkdir -p ./dashboards/uploaded

    cp -rf "./${tempFolder}" "./dashboards/uploaded/${_application_name}"."${dt}"

    func_cleanup

    echo ""
    echo "Checking Transaction configurantion instruction..."
    sleep 2

    #if [ "$configbt" = "configbt" ] || [ "$configbt" = "yes" ] || [ "$configbt" = "bt" ] || [ "$configbt" = "BT" ] || [ "$configbt" = "yes" ]; then
    if [ "${_configure_bt}" = true ]; then
        source ./configBT.sh "$_application_name" "$_user_credentials" "$_controller_url"
    else
        echo ""
        echo "BT Configuration is set to false, not configuring BT"
    fi
    sleep 5

    echo ""
    echo "Done!"

# end of btconfigonly
fi