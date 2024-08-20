// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Reachability",
  platforms: [.macOS(.v14), .iOS(.v16)],
  products: [
    .library(
      name: "Reachability",
      type: .dynamic,
      targets: ["Reachability"])
  ],
  dependencies: [
    .package(path: "../Domain"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.3.7"),
  ],
  targets: [
    .target(
      name: "Reachability",
      dependencies: [
        .product(name: "Domain", package: "Domain"),
        .product(name: "Dependencies", package: "swift-dependencies"),
      ])
  ]
)
