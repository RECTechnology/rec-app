A `key.properties` must be created in each of the folders. One for each of the whitelabel projects. You must copy the `key.properties.dist` and fill with the correct data. 

Then when running the `prepare-android-build.sh` script or `build.sh`, it will copy the appropriate keystore file to the `android` folder.

This allows us to have different keystores for each project. You can read more about this here: https://docs.flutter.dev/deployment/android#signing-the-app