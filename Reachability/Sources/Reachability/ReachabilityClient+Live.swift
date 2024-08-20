//
//  ReachabilityClient+Live.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/20/24.
//

import Combine
import Dependencies
import Network

extension ReachabilityClient {
  public static func live(queue: DispatchQueue) -> Self {
    let monitor = NWPathMonitor()

    return Self {
      AsyncStream { continuation in
        monitor.pathUpdateHandler = { path in
          continuation.yield(NetworkPath(rawValue: path))
        }
        continuation.onTermination = { _ in monitor.cancel() }
        monitor.start(queue: queue)
      }
    }
  }
}

// MARK: - PathMonitorClient + DependencyKey

extension ReachabilityClient: DependencyKey {
  public static let liveValue = ReachabilityClient.live(queue: .main)
  public static let testValue = ReachabilityClient.satisfied
}

extension DependencyValues {
  public var reachabilityClient: ReachabilityClient {
    get { self[ReachabilityClient.self] }
    set { self[ReachabilityClient.self] = newValue }
  }
}
