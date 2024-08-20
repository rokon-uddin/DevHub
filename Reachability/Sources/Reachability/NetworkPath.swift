//
//  NetworkPath.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/20/24.
//

import Domain
import Foundation
import Network

public struct NetworkPath: Equatable {
  public var reachability: Reachability

  public init(reachability: Reachability) {
    self.reachability = reachability
  }
}

extension NetworkPath {
  public init(rawValue: NWPath) {
    let interface: Reachability.Interface =
      rawValue.usesInterfaceType(.wifi) ? .wifi : .cellular
    self.reachability =
      rawValue.status == .satisfied ? .connected(interface: interface) : .notConnected
  }
}

public enum Reachability: Equatable {
  case notConnected
  case connected(interface: Interface)

  public enum Interface {
    case wifi
    case cellular
  }

  public var isOnline: Bool {
    isConnectedWithWifi || isConnectedWithCellular
  }

  public var isConnectedWithWifi: Bool {
    switch self {
    case .connected(let interface): return interface == .wifi
    default: return false
    }

  }

  public var isConnectedWithCellular: Bool {
    switch self {
    case .connected(let interface): return interface == .cellular
    default: return false
    }
  }
}
