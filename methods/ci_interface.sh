#!/bin/bash

function login_and_validate_api() {
    local SERVER="$1"
    local API_KEY="$2"
    local ORG="$3"
    local API_FQN="$4"
    local YAML_FILE_PATH="$5"
    
    login_with_api_key "$SERVER" "$API_KEY"
    ensure_draft_api "$SERVER" "$ORG" "$API_FQN" "$YAML_FILE_PATH"
    validate_api "$SERVER" "$ORG" "$API_FQN"
}

function create_git_release_tag() {
    local TAG="$1"
    local MESSAGE="$2"
    
    if ! git rev-parse "$TAG" >/dev/null 2>&1; then
        git tag "$TAG" -m "$MESSAGE"
    fi
}

function is_ref_up_to_date() {
    local HEAD_REF="$1"
    local BASE_REF="$2"
    git merge-base --is-ancestor "$BASE_REF" "$HEAD_REF" 
}