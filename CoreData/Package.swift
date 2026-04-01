// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CoreData",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "CoreData",
            targets: ["CoreData"]),
    ],
    dependencies: [
        .package(path: "../CoreDomain")
    ],
    targets: [
        .target(
            name: "CoreData",
            dependencies: [
                .product(name: "CoreDomain", package: "CoreDomain")
            ]
        ),
        .testTarget(
            name: "CoreDataTests",
            dependencies: [
                "CoreData",
                .product(name: "CoreDomain", package: "CoreDomain")
            ]
        ),
    ]
)
