// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WhoopAWSWrapper",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "WhoopAWSWrapper",
            type: .dynamic,
            targets: ["WhoopAWSWrapper"]
        ),
    ],
    dependencies: [
        // Updated to latest version for Swift 6 compatibility
        .package(url: "https://github.com/awslabs/aws-sdk-swift", from: "1.6.0")
    ],
    targets: [
        .target(
            name: "WhoopAWSWrapper",
            dependencies: [
                .product(name: "AWSCognitoIdentityProvider", package: "aws-sdk-swift")
            ]
        ),
        .testTarget(
            name: "WhoopAWSWrapperTests",
            dependencies: [
                "WhoopAWSWrapper",
                .product(name: "AWSCognitoIdentityProvider", package: "aws-sdk-swift")
            ]
        ),
    ]
)

