// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ModuleInterface",
    products: [
        .executable(name: "moduleinterface", targets: ["ModuleInterface"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.26.0"),
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.15.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
        .package(url: "https://github.com/eneko/SourceDocs.git", from: "0.2.0"),
        .package(url: "https://github.com/thoughtbot/Curry.git", from: "4.0.1"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.35.8"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ModuleInterface",
            dependencies: ["SourceKittenFramework", "Commandant", "Rainbow", "Curry", "SwiftFormat"]
        ),
        .testTarget(
            name: "ModuleInterfaceTests",
            dependencies: ["ModuleInterface"]
        ),
    ]
)
