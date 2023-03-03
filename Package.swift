// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "NavigationBackport",
  platforms: [
    .iOS(.v14), .watchOS(.v7), .macOS(.v11), .tvOS(.v14),
  ],
  products: [
    .library(
      name: "NavigationBackport",
      targets: ["NavigationBackport"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/YusukeHosonuma/SwiftPrettyPrint.git", exact: "1.4.0")
  ],
  targets: [
    .target(
      name: "NavigationBackport",
      dependencies: ["PrettyPrintSwift"]
    ),
    .testTarget(
      name: "NavigationBackportTests",
      dependencies: ["NavigationBackport"]
    ),
  ]
)
