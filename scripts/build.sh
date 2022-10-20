#!/bin/bash
# This script is a helper for building the app for android, for a certain whitelabel project and environment
# Usage: build.sh <env> <project>


help() {
    echo "Usage: build.sh <env> <project>"
    echo "  * env: [pre, prod, sandbox]"
    echo "  * proj: [rec, larosa]"
}

# TODO: Check that env is correct
if [ -z "$1" ]; then
    echo "No environment supplied, allowed: [pre, prod, sandbox]"
    help
    exit 1
fi

# TODO: Check that project is correct
if [ -z "$2" ]; then
    echo "No project supplied, allowed: [rec, larosa]"
    help
    exit 1
fi

./scripts/prepare-whitelabel.sh $1 $2

./scripts/prepare-android-build.sh $2

echo "Building app flavor: $2_$1"

flutter build apk --release --flavor="$2_$1" --ignore-deprecation