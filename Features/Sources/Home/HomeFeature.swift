//
//  HomeFeature.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Common
import ComposableArchitecture
import Domain
import Reachability
import SwiftUI
import UserDetail

@Reducer
public struct HomeFeature {
  @Reducer(state: .equatable)
  public enum Path {
    case detail(UserDetailFeature)
  }

  @ObservableState
  public struct State: Equatable {
    var path = StackState<Path.State>()
    var usersList = UserListFeature.State()
    var isOnline = true

    public init() {}
  }

  public enum Action {
    case onAppear
    case path(StackActionOf<Path>)
    case usersList(UserListFeature.Action)
    case updateReachability(isOnline: Bool)
  }

  @Dependency(\.reachabilityClient) var reachabilityClient
  public init() {}

  public var body: some ReducerOf<Self> {
    Scope(state: \.usersList, action: \.usersList) {
      UserListFeature()
    }
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          for try await networkPath in await reachabilityClient.networkPathPublisher() {
            let isOnline = networkPath.reachability.isOnline
            await send(.updateReachability(isOnline: isOnline))
          }
        }
      case let .updateReachability(isOnline):
        state.isOnline = isOnline
        return .none
      case .usersList:
        return .none
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}
