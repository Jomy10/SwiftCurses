// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let targets: [Target]
#if canImport(FoundationNetworking)
targets = [
    .systemLibrary(
        name: "C_ncurses",
        pkgConfig: "ncurses",
        providers: [
            .brew(["ncurses"]),
            .apt(["libncurses5-dev"]),
            .yum(["ncurses-devel"])
        ]),

    .systemLibrary(
        name: "C_ncursesw",
        pkgConfig: "ncursesw",
        providers: [
            .brew(["ncurses"]),
            .apt(["libncursesw5-dev"]),
            .yum(["ncurses-devel"])
        ]),

    .target(
        name: "SwiftCurses",
        dependencies: [
            "C_ncurses",
            "C_ncursesw",
        ]),

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
#else
targets = [
    .systemLibrary(
        name: "C_ncurses",
        providers: [
            .brew(["ncurses"]),
            .apt(["libncurses5-dev", "libncursesw5-dev"]),
            .yum(["ncurses-devel"])
        ]),

    .target(
        name: "SwiftCurses",
        dependencies: [
            "C_ncurses",
        ],
        swiftSettings: [
          .define("SWIFTCURSES_OPAQUE")
        ]),

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
#endif

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
    targets: targets)
