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

# Production web must call the API same-origin (Vercel rewrites → Render) so session/CSRF cookies work.
# Direct cross-origin calls (Vercel app → Render host) are blocked by browser cookie rules → 403.
if [[ -z "${API_BASE_URL:-}" ]]; then
  if [[ "${VERCEL:-}" == "1" ]]; then
    API_BASE_URL="same-origin"
  else
    echo "ERROR: Set API_BASE_URL in Vercel to same-origin (proxied) or your Render URL for local builds."
    exit 1
  fi
fi

echo "API_BASE_URL=$API_BASE_URL" > .env
flutter pub get
flutter build web --release
echo "Built $(pwd)/build/web"
