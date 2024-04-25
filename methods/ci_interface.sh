#!/bin/bash

function login_and_validate() {
    local SERVER="$1"
    local API_KEY="$2"
    local ORG="$3"
    local TYPE="$4"
    local FQN="$5"
    local YAML_FILE_PATH="$6"
    
    login_with_api_key "$SERVER" "$API_KEY"
    ensure_draft "$SERVER" "$ORG" "$TYPE" "$FQN" "$YAML_FILE_PATH"
    validate_api_or_product "$SERVER" "$ORG" "$TYPE" "$FQN"
}

function create_git_release_tag() {
    local TAG="$1"
    local MESSAGE="$2"
    
    if ! git rev-parse "$TAG" >/dev/null 2>&1; then
        git tag "$TAG" -m "$MESSAGE"
    fi
}

function git_push_ref() {
    local REF="$1"
    local REMOTE="$2"
    git push -u "$REMOTE" "$REF"
}

function is_ref_up_to_date() {
    local BASE_REF="$1"
    local HEAD_REF="$2"
    git merge-base --is-ancestor "origin/${BASE_REF}" "$HEAD_REF" 
    return $?
}

function post_bitbucket_build_status() {
    local REF="$1"
    local BUILD_STATUS_JSON_FILE="$2"
    local API_BASE_URL="$3"
    local GIT_TOKEN="$4"

    curl -X POST -H 'Content-Type: application/json' \
        -H "Authorization: Bearer ${GIT_TOKEN}" \
        -d @bitbucket-build-status.json \
        "${API_BASE_URL}/rest/build-status/1.0/commits/${REF}"
}