#!/usr/bin/env bash
# Vercel build when novora_flutter is its own GitHub repo (repo root = this folder).
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v flutter >/dev/null 2>&1; then
  echo "Installing Flutter (stable) for web build..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 /tmp/flutter
  export PATH="/tmp/flutter/bin:$PATH"
  flutter config --enable-web
  flutter precache --web
fi

if [[ -z "${API_BASE_URL:-}" ]]; then
  echo "ERROR: Set API_BASE_URL in Vercel (your Render API URL, e.g. https://novora-api.onrender.com)."
  exit 1
fi

echo "API_BASE_URL=$API_BASE_URL" > .env
flutter pub get
flutter build web --release
echo "Built $(pwd)/build/web"
