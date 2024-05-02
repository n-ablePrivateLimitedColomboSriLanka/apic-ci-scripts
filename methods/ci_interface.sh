#!/bin/bash

function login_and_validate() {
    local SERVER="$1"
    local API_KEY="$2"
    local ORG="$3"
    local TYPE="$4"
    local FQN="$5"
    local YAML_FILE_PATH="$6"
    
    login_and_ensure_draft "$SERVER" "$API_KEY" "$ORG" "$TYPE" "$FQN" "$YAML_FILE_PATH"
    validate_api_or_product "$SERVER" "$ORG" "$TYPE" "$FQN"
}

function login_and_ensure_draft() {
    local SERVER="$1"
    local API_KEY="$2"
    local ORG="$3"
    local TYPE="$4"
    local FQN="$5"
    local YAML_FILE_PATH="$6"
    
    login_with_api_key "$SERVER" "$API_KEY"
    ensure_draft "$SERVER" "$ORG" "$TYPE" "$FQN" "$YAML_FILE_PATH"
}

function create_git_release_tag() {
    local TAG="$1"
    local MESSAGE="$2"
    echo "TAG: $TAG"
    echo "MESSAGE: $MESSAGE"
    
    if ! git rev-parse "$TAG" >/dev/null 2>&1; then
        git tag "$TAG" -m "$MESSAGE"
    fi
}

function git_commit() {
    local BRANCH="$1"
    local MESSAGE="$2"
    local SUB_PATH="${3:-'.'}"
    echo "SUB_PATH: $SUB_PATH"
    echo "BRANCH: $BRANCH"
    echo "MESSAGE: $MESSAGE"
    cd "$SUB_PATH"
    git checkout "$BRANCH"
    git add -A
    git commit -m "$MESSAGE"
}

function git_push_ref() {
    local REMOTE="$1"
    local REF="$2"
    local GIT_CRED="$3"
    local SUB_PATH="${4:-'.'}"
    echo "REMOTE: $REMOTE"
    echo "REF: $REF"
    echo "SUB_PATH: $SUB_PATH"
    
    cd "$SUB_PATH"
    git_with_basic_auth "$GIT_CRED" push -u origin "$REF"
}

function is_ref_up_to_date() {
    local BASE_REF="$1"
    local HEAD_REF="$2"
    git merge-base --is-ancestor "origin/${BASE_REF}" "$HEAD_REF" 
    return $?
}

function add_release_submodule_to_index() {
    local INDEX_SUB_PATH="$1"
    local RELEASE_REPO_CLONE_URL="$2"
    local RELEASE_TAG="$3"
    local FQN="$4"
    local GIT_CRED="$5"

    cd "$INDEX_SUB_PATH"
    git_with_basic_auth "$GIT_CRED" clone -b "$RELEASE_TAG" --depth 1 "$RELEASE_REPO_CLONE_URL" "$FQN"
    git submodule add -b "$RELEASE_TAG" "$RELEASE_REPO_CLONE_URL" "$FQN"
}

function post_bitbucket_build_status() {
    local REF="$1"
    local BUILD_STATUS_JSON_FILE="$2"
    local API_BASE_URL="$3"
    local GIT_TOKEN="$4"

    curl -s -X POST -H 'Content-Type: application/json' \
        -H "Authorization: Bearer ${GIT_TOKEN}" \
        -d @bitbucket-build-status.json \
        "${API_BASE_URL}/rest/build-status/1.0/commits/${REF}"
}

function publish_product() {
    local SERVER="$1"
    local ORG="$2"
    local CATALOG="$3"
    local YAML_FILE_PATH="$4"
    local API_KEY="$5"
    local STAGE="${6:-false}"
    if [ "$STAGE" = true ]; then
        STAGE_OPTION=" --stage"
    fi
    
    login_with_api_key "$SERVER" "$API_KEY"
    PUBLISH_CMD="apic products:publish$STAGE_OPTION --server $SERVER --org $ORG --catalog $CATALOG $YAML_FILE_PATH"
    ls -l
    $PUBLISH_CMD
}