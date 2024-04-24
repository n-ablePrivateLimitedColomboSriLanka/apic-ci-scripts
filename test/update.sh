#!/bin/bash

# Testing purposes
function retrieve() {
    local URL="$1"
    test -f /tmp/apic-ci-scripts.zip && rm /tmp/apic-ci-scripts.zip
    curl -J "$URL" -o /tmp/apic-ci-scripts.zip
    unzip -o /tmp/apic-ci-scripts.zip -d /apic-ci-scripts
}

retrieve "http://lib-zipper:5000/zipper/apic-ci-scripts"