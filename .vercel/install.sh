#!/usr/bin/env bash
set -euo pipefail

echo "[Vercel] Install Flutter SDK"
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable flutter
fi
export PATH="$(pwd)/flutter/bin:$PATH"
flutter --version
flutter config --enable-web
flutter doctor -v || true
