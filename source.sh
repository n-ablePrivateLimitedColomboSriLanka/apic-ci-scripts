#!/bin/bash

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source $SCRIPT_ROOT/auth/login.sh
source $SCRIPT_ROOT/methods/utils.sh
source $SCRIPT_ROOT/methods/ci_interface.sh