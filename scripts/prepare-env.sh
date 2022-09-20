#!/bin/bash
# This script copies the <env>.env for the project from `./env/<project>/<env>.env` to `./env/.env`

# The location of the envs
baseEnvPath='env'

# The folder inside env where the project is located
envPath=$2

# Name of the environment
env=$1

if [ -z "$1" ]; then
    echo "No environment supplied, allowed: [pre, prod, sandbox]"
    exit 1
fi

if [ -z "$2" ]; then
    envPath='env/rec'
else
    envPath="env/$2"
fi

cp "$envPath/$env.env" "$baseEnvPath/.env" 
echo "Copied '$envPath/$env.env' to '$baseEnvPath/.env'"
