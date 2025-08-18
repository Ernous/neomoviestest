#!/usr/bin/env bash
set -euo pipefail

export PATH="$(pwd)/flutter/bin:$PATH"

echo "[Vercel] Pub get"
cd flutter_wasm_frontend
flutter pub get

echo "[Vercel] Build Flutter Web (WASM)"
flutter build web --wasm --release

echo "[Vercel] Build done. Output: build/web"
