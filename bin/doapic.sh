#!/bin/bash

METHOD="$1"
shift 1
ARGS="$@"

SCRIPT_DIR="/apic-ci-scripts"
source "$SCRIPT_DIR/source.sh"
init_env

$METHOD $ARGS