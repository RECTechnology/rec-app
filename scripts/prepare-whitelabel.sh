#!/bin/bash
# DOCS available here: https://github.com/QbitArtifacts/rec_app_v2/wiki/Whitelabel-Guide
# This script prepares the project to be run or built, copies assets and env

set -e

# $1 -> Env name
# $2 -> Project name

# Make sure launch_icons are properly generated
./scripts/prepare-icons.sh

# Sets up correct environment for project
./scripts/prepare-env.sh $1 $2

# Copies assets for project
./scripts/prepare-assets.sh $2
