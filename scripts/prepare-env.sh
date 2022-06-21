#!/bin/bash
envPath='env'
env=$1

if [ -z "$1" ]; then
    echo "No environment supplied, allowed: [pre, prod, local, sandbox]"
    exit 1
fi

cp "$envPath/$env.env" "$envPath/.env" 
echo "Copied '$envPath/$env.env' to '$envPath/.env'"
