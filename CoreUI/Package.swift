// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CoreUI",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "CoreUI",
            targets: ["CoreUI"]),
    ],
    dependencies: [
        .package(path: "../CoreDomain")
    ],
    targets: [
        .target(
            name: "CoreUI",
            dependencies: [
                .product(name: "CoreDomain", package: "CoreDomain")
            ]
        ),
        .testTarget(
            name: "CoreUITests",
            dependencies: [
                "CoreUI",
                .product(name: "CoreDomain", package: "CoreDomain")
            ]
        ),
    ]
)
