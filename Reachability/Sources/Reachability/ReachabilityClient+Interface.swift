//
//  ReachabilityClient+Interface.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/20/24.
//

import Network

public struct ReachabilityClient {
  public var networkPathPublisher: @Sendable () async -> AsyncStream<NetworkPath>

  public init(networkPathPublisher: @escaping @Sendable () async -> AsyncStream<NetworkPath>) {
    self.networkPathPublisher = networkPathPublisher
  }
}
