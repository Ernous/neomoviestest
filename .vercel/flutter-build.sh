#!/bin/bash
set -e
export PATH="$PATH:/usr/local/flutter/bin"
flutter build web --wasm --release --dart-define=API_BASE_URL=https://api.neomovies.ru
