// swift-tools-version: 6.2
import PackageDescription
import Foundation

let packageRoot = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
let useLocalDeps = ProcessInfo.processInfo.environment["AISTACK_USE_LOCAL_DEPS"] == "1"
    || ProcessInfo.processInfo.environment["MEMBRANE_USE_LOCAL_DEPS"] == "1"

// Conduit and Wax are always resolved by path (sibling submodules under
// Vendor/Conduit and Vendor/Wax in the OneWorkspace consumer) so the OneApp
// Anthropic patches on Conduit's fork main are what compiles, and so the Wax
// identity matches consumers that path-pin it too (avoids SwiftPM
// "Conflicting identity for wax" errors). Hive/ContextCore remain URL-pinned
// to upstream until forked. See OneWorkspace skill `vendor-cohort-forking`.
var dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.0"),
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

if useLocalDeps {
    dependencies += [
        .package(path: packageRoot.appendingPathComponent("../Hive").path),
        .package(path: packageRoot.appendingPathComponent("../ContextCore").path),
    ]
} else {
    dependencies += [
        // Keep Hive pinned to Swarm's dependency (avoid mixing local/remote HiveCore in the graph).
        .package(url: "https://github.com/christopherkarani/Hive", from: "0.1.9"),
        .package(url: "https://github.com/christopherkarani/ContextCore.git", from: "1.0.0"),
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
