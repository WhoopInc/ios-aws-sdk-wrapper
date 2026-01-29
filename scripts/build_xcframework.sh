#!/bin/bash

set -e

PACKAGE_NAME="WhoopAWSWrapper"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUTPUT_DIR="${OUTPUT_DIR:-${PACKAGE_DIR}/build}"
XCFRAMEWORK_PATH="${OUTPUT_DIR}/${PACKAGE_NAME}.xcframework"

echo "🔨 Building XCFramework for ${PACKAGE_NAME}..."
echo "📦 Output directory: ${OUTPUT_DIR}"
echo "📁 Package directory: ${PACKAGE_DIR}"

# Clean previous builds
rm -rf "${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}"

# Step 1: Ensure Xcode workspace exists
echo ""
echo "📝 Step 1: Checking for Xcode workspace..."

WORKSPACE_PATH=""
if [ -d "${PACKAGE_DIR}/${PACKAGE_NAME}.xcworkspace" ]; then
    WORKSPACE_PATH="${PACKAGE_DIR}/${PACKAGE_NAME}.xcworkspace"
    echo "   ✅ Found workspace: ${PACKAGE_NAME}.xcworkspace"
elif [ -d "${PACKAGE_DIR}/.swiftpm/xcode" ]; then
    WORKSPACE_PATH=$(find "${PACKAGE_DIR}/.swiftpm/xcode" -name "*.xcworkspace" -type d | head -1)
    if [ -n "$WORKSPACE_PATH" ]; then
        echo "   ✅ Found workspace in .swiftpm: $(basename "${WORKSPACE_PATH}")"
    fi
fi

# If no workspace found, we need to create one
if [ -z "$WORKSPACE_PATH" ] || [ ! -d "$WORKSPACE_PATH" ]; then
    echo "   ⚠️  No workspace found. Opening package in Xcode to generate workspace..."
    echo "   (Xcode will open - wait for it to finish resolving packages)"
    echo ""
    echo "   Please:"
    echo "   1. Wait for Xcode to finish opening and resolving packages"
    echo "   2. You can close Xcode once packages are resolved"
    echo "   3. Then press Enter to continue..."
    
    open "${PACKAGE_DIR}/Package.swift" 2>/dev/null || {
        echo "   Could not open Xcode automatically."
        echo "   Please manually open: ${PACKAGE_DIR}/Package.swift"
    }
    
    read -r
    
    # Check again for workspace
    if [ -d "${PACKAGE_DIR}/${PACKAGE_NAME}.xcworkspace" ]; then
        WORKSPACE_PATH="${PACKAGE_DIR}/${PACKAGE_NAME}.xcworkspace"
        echo "   ✅ Workspace created successfully"
    elif [ -d "${PACKAGE_DIR}/.swiftpm/xcode" ]; then
        WORKSPACE_PATH=$(find "${PACKAGE_DIR}/.swiftpm/xcode" -name "*.xcworkspace" -type d | head -1)
        if [ -n "$WORKSPACE_PATH" ]; then
            echo "   ✅ Found workspace in .swiftpm"
        fi
    fi
    
    if [ -z "$WORKSPACE_PATH" ] || [ ! -d "$WORKSPACE_PATH" ]; then
        echo ""
        echo "   ❌ Workspace still not found."
        echo "   Please ensure Xcode has finished resolving packages, then run this script again."
        exit 1
    fi
fi

# Step 2: Archive for iOS device
echo ""
echo "📱 Step 2: Archiving for iOS device (arm64)..."
echo "   This may take a few minutes..."

xcodebuild archive \
    -workspace "${WORKSPACE_PATH}" \
    -scheme "${PACKAGE_NAME}" \
    -destination "generic/platform=iOS" \
    -archivePath "${OUTPUT_DIR}/iOS" \
    SKIP_INSTALL=NO \
    -quiet || {
    echo ""
    echo "   ❌ Archive failed. Error details above."
    exit 1
}

# Step 3: Archive for iOS Simulator
echo ""
echo "💻 Step 3: Archiving for iOS Simulator (arm64 + x86_64)..."
echo "   This may take a few minutes..."

xcodebuild archive \
    -workspace "${WORKSPACE_PATH}" \
    -scheme "${PACKAGE_NAME}" \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "${OUTPUT_DIR}/iOS-Simulator" \
    SKIP_INSTALL=NO \
    -quiet || {
    echo ""
    echo "   ❌ Archive failed. Error details above."
    exit 1
}

# Step 4: Find frameworks in archives
echo ""
echo "📦 Step 4: Looking for frameworks in archives..."

IOS_FRAMEWORK=$(find "${OUTPUT_DIR}/iOS.xcarchive" -name "${PACKAGE_NAME}.framework" -type d 2>/dev/null | head -1)
SIM_FRAMEWORK=$(find "${OUTPUT_DIR}/iOS-Simulator.xcarchive" -name "${PACKAGE_NAME}.framework" -type d 2>/dev/null | head -1)

if [ -z "$IOS_FRAMEWORK" ] || [ -z "$SIM_FRAMEWORK" ]; then
    echo ""
    echo "❌ Error: Could not find frameworks in archives"
    echo "   iOS Framework: ${IOS_FRAMEWORK:-NOT FOUND}"
    echo "   Simulator Framework: ${SIM_FRAMEWORK:-NOT FOUND}"
    echo ""
    echo "   This is expected when BUILD_LIBRARY_FOR_DISTRIBUTION=YES cannot be used."
    echo "   Swift packages may not produce frameworks in archives without this flag."
    echo ""
    echo "   Archive contents:"
    echo "   iOS archive:"
    find "${OUTPUT_DIR}/iOS.xcarchive" -type f -name "*.framework" -o -name "*.a" -o -name "*.swiftmodule" 2>/dev/null | head -10
    echo "   Simulator archive:"
    find "${OUTPUT_DIR}/iOS-Simulator.xcarchive" -type f -name "*.framework" -o -name "*.a" -o -name "*.swiftmodule" 2>/dev/null | head -10
    exit 1
fi

echo "   Found iOS framework: ${IOS_FRAMEWORK}"
echo "   Found Simulator framework: ${SIM_FRAMEWORK}"

# Step 5: Create XCFramework
echo ""
echo "📦 Step 5: Creating XCFramework..."
xcodebuild -create-xcframework \
    -framework "${IOS_FRAMEWORK}" \
    -framework "${SIM_FRAMEWORK}" \
    -output "${XCFRAMEWORK_PATH}"

# Step 6: Create zip file
echo ""
echo "📦 Step 6: Creating zip file..."
ZIP_PATH="${OUTPUT_DIR}/${PACKAGE_NAME}.xcframework.zip"
cd "${OUTPUT_DIR}"
zip -r "${PACKAGE_NAME}.xcframework.zip" "${PACKAGE_NAME}.xcframework" > /dev/null 2>&1
cd - > /dev/null
echo "   ✅ Created: ${ZIP_PATH}"

echo ""
echo "✅ XCFramework created successfully!"
echo "📍 Location: ${XCFRAMEWORK_PATH}"
echo "📍 Zip file: ${ZIP_PATH}"
