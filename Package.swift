// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "AlwaysOnTop",
    defaultLocalization: "en",
    platforms: [.macOS(.v11)],
    products: [
        .executable(name: "AlwaysOnTop", targets: ["AlwaysOnTop"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AlwaysOnTop",
            dependencies: []
        )
    ]
)
