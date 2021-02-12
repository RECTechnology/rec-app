#!/bin/bash

echo "This script replaces env file for specifiec environment (pre, prod, local)";

if [ -z "$1" ]; then
    echo "No environment supplied, allowed: [pre, prod, local]"
    exit 1
fi
