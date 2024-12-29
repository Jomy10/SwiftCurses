// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var targets: [Target] = [
  .systemLibrary(
      name: "C_ncurses",
      pkgConfig: "ncurses",
      providers: [
          .apt(["libncurses5-dev"]),
      ]),
    .target(
        name: "C_ncursesBinds",
        dependencies: ["C_ncurses"],
        cSettings: [
          .headerSearchPath("../C_ncurses")
        ]),
    .target(
        name: "SwiftCurses",
        dependencies: [
            "C_ncurses",
            "C_ncursesBinds",
        ],
        swiftSettings: []),
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

#if os(macOS)
targets
  .first(where: { $0.name == "SwiftCurses" })!
  .swiftSettings!
  .append(.define("SWIFTCURSES_OPAQUE"))
#else
targets.append(
  .systemLibrary(
      name: "C_ncursesw",
      pkgConfig: "ncursesw",
      providers: [
          .brew(["ncurses"]),
          .apt(["libncursesw5-dev"]),
          .yum(["ncurses-devel"])
      ])
)
targets
  .first(where: { $0.name == "SwiftCurses" })!
  .dependencies
  .append("C_ncursesw")
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
