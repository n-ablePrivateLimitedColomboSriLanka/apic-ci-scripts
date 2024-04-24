#!/bin/bash

function login_with_api_key() {
    local SERVER="$1"
    local API_KEY="$2"
    apic login -s "$SERVER" --apiKey "$API_KEY" --sso --context provider
}

function login_with_user_pass () {
    local SERVER="$1"
    local USER="$2"
    local PASSWORD="$3"
    local IDP="${4:-provider/default-idp-2}"
    apic login -s "$SERVER" -u "$USER" -p "$PASSWORD" --realm "$IDP"
}