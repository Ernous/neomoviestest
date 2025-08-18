#!/bin/bash
set -e

echo "Installing Flutter SDK..."
git clone https://github.com/flutter/flutter.git /usr/local/flutter
export PATH="$PATH:/usr/local/flutter/bin"

echo "Flutter version:"
flutter --version

echo "Installing Flutter dependencies..."
flutter pub get

echo "Flutter installation completed!"
