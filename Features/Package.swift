// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Features",
  platforms: [.macOS(.v14), .iOS(.v16)],
  products: [
    .library(
      name: "Home",
      targets: ["Home"]
    ),
    .library(
      name: "UserDetail",
      targets: ["UserDetail"]
    ),
    .library(
      name: "RepositoryList",
      targets: ["RepositoryList"]
    ),
  ],
  dependencies: [
    .package(path: "../Domain"),
    .package(path: "../Common"),
    .package(path: "../NetworkPlatform"),
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      from: "1.13.0"
    ),
  ],
  targets: [
    .target(
      name: "Home",
      dependencies: [
        "UserDetail",
        "RepositoryList",
        .product(name: "Domain", package: "Domain"),
        .product(name: "Common", package: "Common"),
        .product(name: "NetworkPlatform", package: "NetworkPlatform"),
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "UserDetail",
      dependencies: [
        .product(name: "Domain", package: "Domain"),
        .product(name: "Common", package: "Common"),
        .product(name: "NetworkPlatform", package: "NetworkPlatform"),
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "RepositoryList",
      dependencies: [
        "UserDetail",
        .product(name: "Domain", package: "Domain"),
        .product(name: "Common", package: "Common"),
        .product(name: "NetworkPlatform", package: "NetworkPlatform"),
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"),
      ]
    ),
  ]
)
