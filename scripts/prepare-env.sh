#!/bin/bash

envPath='lib/Environments/env'
env=$1

if [ -z "$1" ]; then
    echo "No environment supplied, allowed: [pre, prod, local]"
    exit 1
fi

cp "$envPath-$env.dart" "$envPath.dart" 
echo "Copied '$envPath-$env.dart' to '$envPath.dart'"
