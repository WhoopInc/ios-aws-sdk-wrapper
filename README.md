# WhoopAWSWrapper

A Swift wrapper for AWS Cognito Identity Provider that abstracts AWS SDK types from the Whoop iOS app, providing a clean, type-safe interface without direct exposure to AWS-specific implementations.

## Purpose

This package serves as an abstraction layer between the Whoop iOS app and the AWS Cognito SDK. By encapsulating all AWS types internally, it allows the main application to work with custom, domain-specific types while keeping AWS implementation details hidden. This provides:

- **Type Safety**: Custom types that match the app's domain model
- **Decoupling**: The main app doesn't depend on AWS SDK types
- **Maintainability**: Changes to AWS SDK can be isolated to this package

## Installation

Add this package as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/WhoopInc/ios-aws-sdk-wrapper.git", from: "1.0.0")
]
```

Then add it to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "WhoopAWSWrapper", package: "ios-aws-sdk-wrapper")
    ]
)
```

## Architecture

### Public Interface

The package exposes a public protocol `WhoopCognitoClientProtocol` with custom types that abstract AWS SDK methods


## Key Features

- **Type Abstraction**: All AWS SDK types are encapsulated internally
- **Custom HTTP Client**: Support for injecting custom `URLSession` instances
- **Error Handling**: Proper error propagation from AWS SDK

## Distribution

The package ships to the iOS app as a pre-compiled `WhoopAWSWrapper.xcframework` attached to a GitHub release.

### 1. Build the XCFramework

From the repo root:

```bash
./scripts/build_xcframework.sh
```

This archives the framework for iOS device and iOS Simulator and combines them into `build/WhoopAWSWrapper.xcframework`. `build/` is deleted at the start of each run; set `OUTPUT_DIR` to write elsewhere.

### 2. Zip it and compute the checksum

```bash
(cd build && zip -r WhoopAWSWrapper.xcframework.zip WhoopAWSWrapper.xcframework)
swift package compute-checksum build/WhoopAWSWrapper.xcframework.zip
```

### 3. Publish a release

Tag the release and attach the zip:

```bash
gh release create <version> build/WhoopAWSWrapper.xcframework.zip \
    --title "<version>" \
    --notes "Checksum: <checksum>"
```

### 4. Consume it

Reference the release asset as a binary target:

```swift
.binaryTarget(
    name: "WhoopAWSWrapper",
    url: "https://github.com/WhoopInc/ios-aws-sdk-wrapper/releases/download/<version>/WhoopAWSWrapper.xcframework.zip",
    checksum: "<checksum>"
)
```
