#!/bin/bash

# This script is a helper for running the app, for a certain whitelabel project and environment
# Usage: run.sh <env> <project>

# TODO: Maybe change scripts from using bash to use dart or js for better control

help() {
    echo "This script is a helper for running the app, for a certain whitelabel project and environment"
    echo "Usage: run.sh <env> <project>"
    echo "  * env: [pre, prod, sandbox]"
    echo "  * proj: [rec, larosa]"
}

# TODO: Check that env and project are correct
if [ -z "$1" ]; then
    echo "No environment supplied, allowed: [pre, prod, local, sandbox]"
    help
    exit 1
fi
if [ -z "$2" ]; then
    echo "No project supplied, allowed: [rec, larosa]"
    help
    exit 1
fi

./scripts/prepare-whitelabel.sh $1 $2

echo "Running app flavor: $2_$1"
flutter run --flavor="$2_$1" --ignore-deprecation