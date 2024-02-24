// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "FirebaseX",
    platforms: [.iOS(.v13), .watchOS(.v7), .macCatalyst(.v13), .macOS(.v11)],
    products: [
        .library(
            name: "FirestoreExtension",
            targets: ["FirestoreExtension"]
        ),
        .library(
            name: "RtdbExtension",
            targets: ["RtdbExtension"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.18.0"),
        .package(url: "https://github.com/CombineCommunity/CombineExt", from: "1.8.1")
    ],
    targets: [
        .target(
            name: "FirestoreExtension",
            dependencies: [
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .byName(name: "CombineExt")
            ]
        ),
        .target(
            name: "RtdbExtension",
            dependencies: [
                .productItem(name: "FirebaseDatabase", package: "firebase-ios-sdk"),
                .byName(name: "CombineExt")
            ]
        ),
    ]
)
