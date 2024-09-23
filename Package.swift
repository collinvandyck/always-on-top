// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "AlwaysOnTop",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "AlwaysOnTop", targets: ["AlwaysOnTop"])
    ],
    dependencies: [
        // Add dependencies here, e.g.:
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "AlwaysOnTop",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .testTarget(
            name: "AlwaysOnTopTests",
            dependencies: ["AlwaysOnTop"]),
    ]
)
