#!/bin/bash
help() {
    echo "Usage: build-aab.sh <env> <project>"
    echo "  * env: [pre, prod, sandbox]"
    echo "  * proj: [rec, larosa]"
}

# TODO: Check that env is correct
if [ -z "$1" ]; then
    echo "No environment supplied, allowed: [pre, prod, sandbox]"
    help
    exit 1
fi


./build.sh $1 larosa
./build.sh $1 rec
./build-aab.sh $1 larosa
./build-aab.sh $1 rec