#!/usr/bin/env bash
set -euo pipefail

export PATH="$(pwd)/flutter/bin:$PATH"

echo "[Vercel] Pub get"
cd flutter_wasm_frontend
flutter pub get

echo "[Vercel] Build Flutter Web (WASM)"
flutter build web --wasm --release --dart-define=API_BASE_URL=${API_BASE_URL:-https://api.neomovies.ru}

echo "[Vercel] Build done. Output: build/web"
