#!/bin/bash

help() {
  echo "This script copies the key.properties for the project from `./assets/android-build/<project>/key.properties` to `./android/key.properties`"
  echo "Usage: prepare-android-build.sh <project>"
  echo "  * proj: [rec, larosa]"
}

if [ -z "$1" ]; then
  echo "No project supplied, allowed: [larosa, rec]"
  help
  exit 1
fi

echo "Copying ./assets/android-build/$1/key.properties to ./android/key.properties"
cp ./assets/android-build/$1/key.properties ./android/key.properties
