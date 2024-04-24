#!/bin/bash

function ensure_draft_api() {
    local SERVER="$1"
    local ORG="$2"
    local API_FQN="$3" 
    local YAML_FILE_PATH="$4"
    
    apic draft-apis:get --server "$SERVER" --org "$ORG" "$API_FQN" --output - > /dev/null 2>&1 && \
        apic draft-apis:update --server "$SERVER" --org "$ORG" "$API_FQN" "$YAML_FILE_PATH" || \
            apic draft-apis:create --server "$SERVER" --org "$ORG" "$YAML_FILE_PATH"
}

function validate_api() {
    local SERVER="$1"
    local ORG="$2"
    local API_FQN="$3"
    
    apic draft-apis:validate --server "$SERVER" --org "$ORG" "$API_FQN" && \
        return 0 || return 1
}

function post_bitbucket_build_status() {
    local REF="$1"
    local BUILD_STATUS_JSON_FILE="$2"
    local API_BASE_URL="$3"
    local GIT_TOKEN="$4"
    
    curl -X POST -H 'Content-Type: application/json' \
        -H "Authorization: Bearer $GIT_TOKEN" \
        -d @bitbucket-build-status.json \
        ${API_BASE_URL}/rest/build-status/1.0/commits/${$REF}
}

function init_env() {
    git config --global --add safe.directory $PWD
}