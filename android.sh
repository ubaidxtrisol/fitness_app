#!/bin/bash

set -e

APP_NAME="fitness_app"

VERSION_LINE=$(grep '^version:' pubspec.yaml | sed 's/version:[[:space:]]*//' | cut -d'#' -f1 | xargs)

VERSION_NAME="${VERSION_LINE%%+*}"
VERSION_CODE="${VERSION_LINE##*+}"
APK_NAME="${APP_NAME}_vc_${VERSION_CODE}_vn_${VERSION_NAME}.apk"
AAB_NAME="${APP_NAME}_vc_${VERSION_CODE}_vn_${VERSION_NAME}.aab"

APP_ID="1:2952186361:android:b54c8eae29f45a6b681528"
RELEASE_DIR="release"
DEBUG_INFO_DIR="build/debug-info"

APK_SOURCE="build/app/outputs/flutter-apk/app-release.apk"
AAB_SOURCE="build/app/outputs/bundle/release/app-release.aab"

echo "======================================"
echo "Cleaning project..."
echo "======================================"

flutter clean

echo "======================================"
echo "Getting dependencies..."
echo "======================================"

flutter pub get
rm -rf "$RELEASE_DIR"
echo "======================================"
echo "Creating release directories..."
echo "======================================"

mkdir -p "$RELEASE_DIR"
mkdir -p "$DEBUG_INFO_DIR"

echo "======================================"
echo "Building protected release APK..."
echo "======================================"

flutter build apk \
  --release \
  --obfuscate \
  --split-debug-info="$DEBUG_INFO_DIR" 

echo "======================================"
echo "Building protected release App Bundle..."
echo "======================================"

flutter build appbundle \
  --release \
  --obfuscate \
  --split-debug-info="$DEBUG_INFO_DIR" 

if [ ! -f "$APK_SOURCE" ]; then
  echo "APK not found!"
  exit 1
fi

if [ ! -f "$AAB_SOURCE" ]; then
  echo "AAB not found!"
  exit 1
fi

echo "======================================"
echo "Copying and renaming artifacts..."
echo "======================================"

cp "$APK_SOURCE" "$RELEASE_DIR/$APK_NAME"
cp "$AAB_SOURCE" "$RELEASE_DIR/$AAB_NAME"

echo "======================================"
echo "Uploading Crashlytics symbols..."
echo "======================================"

if [ -d "$DEBUG_INFO_DIR" ]; then
  echo "Debug symbols found."

  # Firebase CLI symbol upload (Works for Android)
  if command -v firebase >/dev/null 2>&1; then
    echo "Uploading symbols to Crashlytics via Firebase CLI..."
    firebase crashlytics:symbols:upload --app="$APP_ID" "$DEBUG_INFO_DIR"
  else
    echo "Firebase CLI not installed. Skipping symbol upload."
    echo "Please install it via: npm install -g firebase-tools"
  fi
else
  echo "Debug symbol directory not found."
fi

echo ""
echo "======================================"
echo "BUILD SUCCESSFUL"
echo "======================================"
echo "APK : $RELEASE_DIR/$APK_NAME"
echo "AAB : $RELEASE_DIR/$AAB_NAME"
echo "Debug Symbols : $DEBUG_INFO_DIR"
echo ""