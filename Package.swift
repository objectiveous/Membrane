// swift-tools-version: 6.2
import PackageDescription
import Foundation

let packageRoot = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
let useLocalDeps = ProcessInfo.processInfo.environment["AISTACK_USE_LOCAL_DEPS"] == "1"
    || ProcessInfo.processInfo.environment["MEMBRANE_USE_LOCAL_DEPS"] == "1"

var dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.0"),
]

if useLocalDeps {
    dependencies += [
        .package(path: packageRoot.appendingPathComponent("../Hive").path),
        .package(path: packageRoot.appendingPathComponent("../ContextCore").path),
        .package(
            path: packageRoot.appendingPathComponent("../Conduit").path,
            traits: [
                .trait(name: "OpenAI"),
                .trait(name: "OpenRouter"),
                .trait(name: "Anthropic"),
            ]
        ),
        .package(path: packageRoot.appendingPathComponent("../Wax").path),
    ]
} else {
    dependencies += [
        .package(url: "https://github.com/christopherkarani/Hive", exact: "0.1.8"),
        .package(url: "https://github.com/christopherkarani/ContextCore.git", exact: "0.1.0"),
        .package(
            url: "https://github.com/christopherkarani/Conduit",
            exact: "0.3.10",
            traits: [
                .trait(name: "OpenAI"),
                .trait(name: "OpenRouter"),
                .trait(name: "Anthropic"),
            ]
        ),
        .package(url: "https://github.com/christopherkarani/Wax.git", exact: "0.1.19"),
    ]
}

let package = Package(
    name: "Membrane",
    platforms: [.macOS(.v26), .iOS(.v26)],
    products: [
        .library(name: "MembraneCore", targets: ["MembraneCore"]),
        .library(name: "Membrane", targets: ["Membrane"]),
        .library(name: "MembraneContextCore", targets: ["MembraneContextCore"]),
        .library(name: "MembraneWax", targets: ["MembraneWax"]),
        .library(name: "MembraneHive", targets: ["MembraneHive"]),
        .library(name: "MembraneConduit", targets: ["MembraneConduit"]),
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "MembraneCore",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections"),
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "Membrane",
            dependencies: [
                "MembraneCore",
                "MembraneContextCore",
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "MembraneContextCore",
            dependencies: [
                "MembraneCore",
                .product(name: "ContextCore", package: "ContextCore"),
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "MembraneWax",
            dependencies: [
                "Membrane",
                .product(name: "Wax", package: "Wax"),
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "MembraneHive",
            dependencies: [
                "Membrane",
                .product(name: "HiveCore", package: "Hive"),
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "MembraneConduit",
            dependencies: [
                "Membrane",
                .product(name: "ConduitAdvanced", package: "Conduit"),
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "MembraneCoreTests",
            dependencies: ["MembraneCore"]
        ),
        .testTarget(
            name: "MembraneTests",
            dependencies: ["Membrane"]
        ),
        .testTarget(
            name: "MembraneWaxTests",
            dependencies: ["MembraneWax"]
        ),
        .testTarget(
            name: "MembraneHiveTests",
            dependencies: ["MembraneHive"]
        ),
        .testTarget(
            name: "MembraneConduitTests",
            dependencies: ["MembraneConduit"]
        ),
    ]
)
