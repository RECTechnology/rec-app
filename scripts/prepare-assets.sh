#!/bin/bash
# This script copies the assets for the project from `./assets/whitelabel/<project>` to `./assets/current`
# So that flutter has access to them, this allows us to set different assets depending on the project

help() {
  echo "This script copies the assets for the project from `./assets/whitelabel/<project>` to `./assets/current`"
  echo "So that flutter has access to them, this allows us to set different assets depending on the project"
  echo "Usage: prepare-assets.sh <project>"
  echo "  * env: [pre, prod, sandbox]"
  echo "  * proj: [rec, larosa]"
}

if [ -z "$1" ]; then
  echo "No project supplied, allowed: [larosa, rec]"
  help
  exit 1
fi

if [ -d ./assets/current ]; then
  echo "Removing ./assets/current"
  rm -r ./assets/current
fi

if [ ! -d ./assets/current ]; then
  echo "Creating ./assets/current"
  mkdir ./assets/current
fi

echo "Copying ./assets/whitelabel/$1/* to ./assets/current"
cp -r ./assets/whitelabel/$1/* ./assets/current

echo "Copying ./assets/whitelabel/shared/* to ./assets/current"
cp -r ./assets/whitelabel/shared/* ./assets/current
