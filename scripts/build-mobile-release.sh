#!/usr/bin/env bash
# Build Android APK / iOS (no codesign) pointing at production Render API.
set -euo pipefail
cd "$(dirname "$0")/.."

API="${API_BASE_URL:-https://novora-api-wf1w.onrender.com}"
DEFINE=(--dart-define="API_BASE_URL=$API")

echo "Using API_BASE_URL=$API"
flutter pub get

case "${1:-apk}" in
  apk)
    flutter build apk --release "${DEFINE[@]}"
    echo "APK: build/app/outputs/flutter-apk/app-release.apk"
    ;;
  appbundle|aab)
    flutter build appbundle --release "${DEFINE[@]}"
    echo "AAB: build/app/outputs/bundle/release/app-release.aab"
    ;;
  ios)
    flutter build ios --release --no-codesign "${DEFINE[@]}"
    echo "Open ios/Runner.xcworkspace in Xcode to archive and upload."
    ;;
  *)
    echo "Usage: $0 [apk|appbundle|ios]"
    exit 1
    ;;
esac
