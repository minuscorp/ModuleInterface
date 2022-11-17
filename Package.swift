// swift-tools-version:5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ModuleInterface",
    products: [
        .executable(
            name: "moduleinterface",
            targets: [
                "ModuleInterface",
            ]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/jpsim/SourceKitten.git", exact: "0.32.0"),
        .package(url: "https://github.com/Carthage/Commandant.git", exact: "0.18.0"),
        .package(url: "https://github.com/onevcat/Rainbow", exact: "3.2.0"),
        .package(url: "https://github.com/eneko/SourceDocs.git", exact: "2.0.1"),
        .package(url: "https://github.com/thoughtbot/Curry.git", exact: "5.0.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", exact: "0.50.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .executableTarget(
            name: "ModuleInterface",
            dependencies: [
                .product(
                    name: "SourceKittenFramework",
                    package: "SourceKitten"
                ),
                "Commandant",
                "Rainbow",
                "Curry",
                "SwiftFormat",
            ]
        ),
        .testTarget(
            name: "ModuleInterfaceTests",
            dependencies: [
                "ModuleInterface",
            ]
        ),
    ]
)
