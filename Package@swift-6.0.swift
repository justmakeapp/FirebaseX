// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "FirebaseX",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "FirebaseFileSync",
            targets: ["FirebaseFileSync"]
        ),
        .library(
            name: "FirebaseAuthExtension",
            targets: ["FirebaseAuthExtension"]
        ),
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
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.27.0"),
        .package(url: "https://github.com/CombineCommunity/CombineExt", from: "1.8.1")
    ],
    targets: [
        .target(
            name: "FirebaseFileSync",
            dependencies: []
        ),
        .target(
            name: "FirebaseAuthExtension",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            ]
        ),
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
                .product(name: "FirebaseDatabase", package: "firebase-ios-sdk"),
                .byName(name: "CombineExt")
            ]
        ),
    ],
    swiftLanguageVersions: [.v6]
)
