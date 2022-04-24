// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Account",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Account",
            targets: ["Account"]),
    ],
    dependencies: [
        .package(name: "Module", path: "/Users/armancarhcan/Desktop/Module"),
        .package(name: "Managers", path: "/Users/armancarhcan/Desktop/Managers"),
        .package(name: "DesignSystem", path: "/Users/armancarhcan/Desktop/DesignSystem"),
        .package(name: "AlertManager", path: "/Users/armancarhcan/Desktop/AlertManager"),
        .package(name: "Utils", path: "/Users/armancarhcan/Desktop/Utils"),
        .package(name: "Selection", path: "/Users/armancarhcan/Desktop/Selection"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Account",
            dependencies: [
                           .product(name: "Managers", package: "Managers"),
                           .product(name: "DesignSystem", package: "DesignSystem"),
                           .product(name: "AlertManager", package: "AlertManager"),
                           .product(name: "Selection", package: "Selection"),
                           .product(name: "Utils", package: "Utils"),
                           .product(name: "Swinject", package: "Swinject")]),
        
    ]
)
