//
//  ReachabilityClient+Interface.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/20/24.
//

import Combine
import Network

public struct ReachabilityClient {
  public var networkPathStream: @Sendable () async -> AsyncStream<NetworkPath>

  public init(networkPathStream: @escaping @Sendable () async -> AsyncStream<NetworkPath>) {
    self.networkPathStream = networkPathStream
  }

}
