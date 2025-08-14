#!/bin/bash
set -e

# Arguments: version type [dev|prod]
TYPE=$1

if [ "$TYPE" == "dev" ]; then
  VERSION_NAME="1.0.${GITHUB_RUN_NUMBER}"
  VERSION_CODE=$GITHUB_RUN_NUMBER
elif [ "$TYPE" == "prod" ]; then
  # Extract version from tag (e.g., v1.2.3 → 1.2.3)
  VERSION_NAME=$(echo $GITHUB_REF_NAME | sed 's/^v//')
  VERSION_CODE=$GITHUB_RUN_NUMBER
else
  echo "Unknown version type: $TYPE"
  exit 1
fi

# Update pubspec.yaml
sed -i "s/^version: .*/version: $VERSION_NAME+$VERSION_CODE/" pubspec.yaml

echo "Version updated to: $VERSION_NAME+$VERSION_CODE"
