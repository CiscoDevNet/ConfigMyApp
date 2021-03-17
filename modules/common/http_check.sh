#!/bin/bash

function func_check_http_status() {
    local http_code=$1
    local message_on_failure=$2
    #echo "HTTP status code: $http_code"
    if [[ $http_code -lt 200 ]] || [[ $http_code -gt 299 ]]; then
        echo "${dt} ERROR "{$http_code: $message_on_failure}"" >> ../../error.log
        echo "ERROR $http_code: $message_on_failure"
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
            echo "${dt} ERROR "{$http_message_body}"" >> ../../error.log
            echo "ERROR $http_message_body"
            exit 1
        fi
}

function func_cleanup() {
    tempFolder=$1
    # remove all from temp folder
    rm -rf $tempFolder
}