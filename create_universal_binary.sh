#!/bin/bash

set -e

# Download Dart SDK for x86_64
echo "Downloading Dart SDK for x86_64..."
curl -sSL "https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-macos-x64-release.zip" -o dart-sdk-x86_64.zip
unzip -q dart-sdk-x86_64.zip -d dart-sdk-x86_64
rm dart-sdk-x86_64.zip
echo "Dart SDK for x86_64 downloaded and extracted."

# Download Dart SDK for arm64
echo "Downloading Dart SDK for arm64..."
curl -sSL "https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-macos-arm64-release.zip" -o dart-sdk-arm64.zip
unzip -q dart-sdk-arm64.zip -d dart-sdk-arm64
rm dart-sdk-arm64.zip
echo "Dart SDK for arm64 downloaded and extracted."

mkdir build/

# Compile Dart program for x86_64
echo "Compiling Dart program for x86_64..."
dart-sdk-x86_64/dart-sdk/bin/dart compile exe bin/adobe_deactivation_bypass.dart -o build/adobe_deactivation_bypass_x86_64
echo "Dart program compiled for x86_64."

# Compile Dart program for arm64
echo "Compiling Dart program for arm64..."
dart-sdk-arm64/dart-sdk/bin/dart compile exe bin/adobe_deactivation_bypass.dart -o build/adobe_deactivation_bypass_arm64
echo "Dart program compiled for arm64."

# Clean up downloaded Dart SDKs
rm -rf dart-sdk-x86_64
rm -rf dart-sdk-arm64

echo "Cleanup complete."
