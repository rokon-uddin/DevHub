//
//  PathMonitorClient+Mocks.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/20/24.
//

import Foundation
import Network

extension ReachabilityClient {
  public static let satisfiedWifi = Self {
    AsyncStream { continuation in
      continuation.yield(NetworkPath(reachability: .connected(interface: .wifi)))
      continuation.finish()
    }
  }

  public static let satisfiedCellular = Self {
    AsyncStream { continuation in
      continuation.yield(NetworkPath(reachability: .connected(interface: .cellular)))
      continuation.finish()
    }
  }

  public static let unsatisfied = Self {
    AsyncStream { continuation in
      continuation.yield(NetworkPath(reachability: .notConnected))
      continuation.finish()
    }
  }
}
