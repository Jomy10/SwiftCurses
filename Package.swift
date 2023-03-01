// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftCurses",
    products: [
        .library(
            name: "SwiftCurses",
            targets: ["SwiftCurses"]),
        .executable(
            name: "Examples",
            targets: ["Examples"])
    ],
    dependencies: [],
    targets: [
        .systemLibrary(
            name: "ncurses",
            providers: [
                .brew(["ncurses"])
                // TODO
            ]),
            
        .target(
            name: "SwiftCurses",
            dependencies: ["ncurses"]),
            
        .executableTarget(
            name: "Examples",
            dependencies: ["SwiftCurses"],
            exclude: ["README.md"],
            swiftSettings: [.unsafeFlags([
                "-Xfrontend",
                "-warn-long-function-bodies=100",
                "-Xfrontend",
                "-warn-long-expression-type-checking=100"
            ])]),

        .testTarget(
            name: "ncursesTests",
            dependencies: ["SwiftCurses"]),
    ]
)
