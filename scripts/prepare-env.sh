#!/bin/bash

<<<<<<< HEAD
echo "This script replaces env file for specifiec environment (pre, prod, local)";
=======
envPath='lib/Environments/env'
env=$1
>>>>>>> main

if [ -z "$1" ]; then
    echo "No environment supplied, allowed: [pre, prod, local]"
    exit 1
fi
<<<<<<< HEAD
=======

cp "$envPath-$env.dart" "$envPath.dart" 
echo "Copied '$envPath-$env.dart' to '$envPath.dart'"
>>>>>>> main
