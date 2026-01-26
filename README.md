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
    .package(url: "https://github.com/WhoopInc/ios-aws-wrapper.git", from: "1.0.0")
]
```

Then add it to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "WhoopAWSWrapper", package: "ios-aws-wrapper")
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

