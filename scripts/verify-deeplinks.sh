#!/bin/zsh

alias adb="/Users/$USER/Library/Android/sdk/platform-tools/adb"

echo "Support the updated domain verification process\n"
adb shell am compat enable 175408749 com.barcelona.rec

echo "Reset the state of Android App Links on a device\n"
adb shell pm set-app-links --package com.barcelona.rec 0 all

echo "Invoke the domain verification process\n"
adb shell pm verify-app-links --re-verify com.barcelona.rec

echo "Waiting for 5 minutes before checking\n"
sleep 100

echo "Review the verification results\n"
adb shell pm get-app-links com.barcelona.rec
