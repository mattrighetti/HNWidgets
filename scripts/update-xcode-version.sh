#!/bin/bash
# Pre-bump hook for Cog to update Xcode version numbers before the release commit.

set -e

PROJECT_FILE="HNWidgets.xcodeproj/project.pbxproj"
NEW_VERSION="${1:-}"

if [ -z "$NEW_VERSION" ]; then
    echo "Error: target version must be supplied by the Cog pre-bump hook" >&2
    exit 1
fi

CURRENT_VERSION=$(grep "MARKETING_VERSION = " "$PROJECT_FILE" | head -1 | sed -E 's/.*MARKETING_VERSION = ([0-9.]+).*/\1/')
CURRENT_BUILD=$(grep "CURRENT_PROJECT_VERSION = " "$PROJECT_FILE" | head -1 | sed -E 's/.*CURRENT_PROJECT_VERSION = ([0-9]+).*/\1/')

if [ "$CURRENT_VERSION" = "$NEW_VERSION" ]; then
    exit 0
fi

NEW_BUILD=$((CURRENT_BUILD + 1))
echo "Updating Xcode version: $CURRENT_VERSION -> $NEW_VERSION (build $NEW_BUILD)"

sed -i.bak "s|MARKETING_VERSION = $CURRENT_VERSION|MARKETING_VERSION = $NEW_VERSION|g" "$PROJECT_FILE"
sed -i.bak "s|CURRENT_PROJECT_VERSION = $CURRENT_BUILD|CURRENT_PROJECT_VERSION = $NEW_BUILD|g" "$PROJECT_FILE"
rm -f "$PROJECT_FILE.bak"

git add "$PROJECT_FILE"
echo "Xcode version updated."
