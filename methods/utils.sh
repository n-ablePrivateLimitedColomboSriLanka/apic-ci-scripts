#!/bin/bash

function ensure_draft() {
    local SERVER="$1"
    local ORG="$2"
    local TYPE="$3"
    local FQN="$4" 
    local YAML_FILE_PATH="$5"
    
    apic draft-${TYPE}:get --server "$SERVER" --org "$ORG" "$FQN" --output - > /dev/null 2>&1 && \
        apic draft-${TYPE}:update --server "$SERVER" --org "$ORG" "$FQN" "$YAML_FILE_PATH" || \
            apic draft-${TYPE}:create --server "$SERVER" --org "$ORG" "$YAML_FILE_PATH"
}

function validate_api_or_product() {
    local SERVER="$1"
    local ORG="$2"
    local TYPE="$3"
    local FQN="$4"
    
    apic draft-${TYPE}:validate --server "$SERVER" --org "$ORG" "$FQN" && \
        return 0 || return 1
}

function git_with_basic_auth() {
    local GIT_CRED="$1"
    shift 1
    git -c http.extraheader="Authorization: Basic $(echo -n "$GIT_CRED" | base64)" "$@"
}


function init_env() {
    git config --global --add safe.directory "*"
    git config --global user.name "Jenkins"
    git config --global user.email "contact@jenkins.com"
}