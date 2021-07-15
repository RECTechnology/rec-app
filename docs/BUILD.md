## Docs for building

### Build android:

Building for prod:
```bash
# Increment version in pubspec.yml
# If not sure ask someone in charge

# Commit new version (replace vX.X.X with correct version)
git commit -am "chore(release): vX.X.X"

# Create tag for version (replace vX.X.X with correct version)
git tag -a vX.X.X
git push --follow-tags

# Setup environment
./scripts/prepare-env.sh prod

# Build apk for prod (for testing)
flutter build apk --flavor=prod --release

# Build AppBundle (AAB) (for uploading to PlayStore)
flutter build appbundle --flavor=prod --release

# Open the path to the apk, usually "build/app/outputs/flutter-apk/"
# Or to the AppBundle,     usually "build/app/outputs/bundle/prodRelease"
open <path/to/build>

# For APK: Rename "app-prod-release.apk" to "RecBarcelona-vX.X.X.apk"
# For AAB: Rename "app-prod-release.aab" to "RecBarcelona-vX.X.X.aab"
```

