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
    API_BASE_URL="${API_BASE_URL:-http://localhost:8080}"
    echo "Local build: using API_BASE_URL=$API_BASE_URL (pass API_BASE_URL=same-origin to mimic Vercel)"
  fi
fi

# Only write .env on Vercel — never clobber a developer's local .env.
if [[ "${VERCEL:-}" == "1" ]]; then
  echo "API_BASE_URL=$API_BASE_URL" > .env
fi
flutter pub get
# dart-define survives web release even if the .env asset fails to load in the browser.
flutter build web --release --dart-define=API_BASE_URL="$API_BASE_URL"
echo "Built $(pwd)/build/web"
