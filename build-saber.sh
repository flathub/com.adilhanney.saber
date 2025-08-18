#!/bin/bash
# This script is used to build Saber from source.

set -x # Show commands as they are executed

echo "Running sanity checks..."
if [ ! -f pubspec.yaml ]; then
    echo "This script must be run from the root of the Saber repository."
    exit 1
fi
if [ ! -d ".pub-cache" ]; then
    echo "Missing .pub-cache directory. Dependencies cannot be fetched at build time."
    exit 1
fi
echo

echo "Setting up environment variables..."
export PUB_CACHE=$(pwd)/.pub-cache
export FLUTTER_ROOT=$(pwd)/submodules/flutter
export PATH="$FLUTTER_ROOT/bin:$PATH"
export PATH="$PUB_CACHE/bin:$PATH"
echo "pub cache: $PUB_CACHE"
echo "Flutter root: $FLUTTER_ROOT"
echo

echo "Setting flutter config..."
flutter config --no-analytics
flutter config --no-cli-animations
flutter doctor -v
echo

echo "Fetching dependencies..."
flutter pub get --offline --enforce-lockfile
echo

echo "Building Saber for Linux..."
flutter build linux
if [ $? -ne 0 ]; then
    exit 1
fi
echo

echo "Copying build artifacts to /app..."
mkdir -p /app
cp -r build/linux/x64/release/bundle/* /app
mkdir -p /app/bin
ln -s /app/saber /app/bin/saber
