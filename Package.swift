// swift-tools-version: 5.9

import Foundation
import PackageDescription

let years: [Int] = [/*2015, */2023]
let enableOptimizations = false

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "AOCKit", targets: ["AOCKit"]),
        .executable(name: "AdventOfCode", targets: ["AdventOfCode"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.0.6"),
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "AOCKit",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Numerics", package: "swift-numerics")
            ],
            path: "AOCKit/Sources",
            swiftSettings: swiftSettings()
        ),
        .testTarget(
            name: "AOCKitTests",
            dependencies: ["AOCKit"],
            path: "AOCKit/Tests",
            swiftSettings: swiftSettings()
        ),
        .executableTarget(
            name: "AdventOfCode",
            dependencies: years.map { .target(name: "AOC\($0)") },
            path: "AdventOfCode",
            swiftSettings: swiftSettings()
        ),
        .executableTarget(
            name: "App",
            dependencies: years.map { .target(name: "AOC\($0)") },
            path: "App",
            swiftSettings: swiftSettings()
        )

    ] + yearTargets()
)

func yearTargets() -> [Target] {
    years.flatMap(targets(for:))
}

func targets(for year: Int) -> [Target] {
    [
        .target(
            name: "AOC\(year)",
            dependencies: ["AOCKit"],
            path: "\(year)/Sources",
            exclude: inputFiles(for: year),
            swiftSettings: swiftSettings()
        ),
        .testTarget(
            name: "AOC\(year)Tests",
            dependencies: [.target(name: "AOC\(year)")],
            path: "\(year)/Tests",
            swiftSettings: swiftSettings()
        )
    ]
}

func inputFiles(for year: Int) -> [String] {
    []
}

func swiftSettings() -> [SwiftSetting] {
    var settings: [SwiftSetting] = [
        .unsafeFlags([
            "-Xfrontend",
            "-warn-concurrency",
            "-enable-actor-data-race-checks",
            "-enable-bare-slash-regex"
        ])
    ]
    if enableOptimizations {
        settings.append(.unsafeFlags(["-O"]))
    }
    
    return settings
}
