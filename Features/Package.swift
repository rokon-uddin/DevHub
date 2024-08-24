// swift-tools-version: 5.10
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
    .package(
      url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
      from: "1.17.4"),
  ],
  targets: [
    .target(
      name: "Home",
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
    .target(
      name: "UserDetail",
      dependencies: [
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
      name: "RepositoryList",
      dependencies: [
        .product(name: "Domain", package: "Domain"),
        .product(name: "Common", package: "Common"),
        .product(name: "NetworkPlatform", package: "NetworkPlatform"),
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"),
      ]
    ),
    .testTarget(
      name: "FeaturesTests",
      dependencies: [
        "Home",
        "UserDetail",
        "RepositoryList",
        .product(name: "Domain", package: "Domain"),
        .product(name: "Common", package: "Common"),
        .product(name: "NetworkPlatform", package: "NetworkPlatform"),
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"),
        .product(
          name: "SnapshotTesting",
          package: "swift-snapshot-testing"),
      ],
      resources: [
        .copy("Resources/Repos_1.json"),
        .copy("Resources/Repos_2.json"),
        .copy("Resources/Repos_Search.json"),
        .copy("Resources/Users_0.json"),
        .copy("Resources/Users_5.json"),
        .copy("Resources/UserDetail.json"),
      ]
    ),
  ]
)
