#!/bin/bash
set -e

# Generate a version name based on date
VERSION_NAME=$(date +'%Y.%m.%d')

# Use GitHub run number as build code
VERSION_CODE=${GITHUB_RUN_NUMBER}

# Update pubspec.yaml
sed -i "s/^version: .*/version: ${VERSION_NAME}+${VERSION_CODE}/" pubspec.yaml

echo "✅ Updated version to ${VERSION_NAME}+${VERSION_CODE}"
