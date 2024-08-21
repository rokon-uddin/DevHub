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
    var showToast = false

    public init() {}
  }

  public enum Action: ViewAction {
    case view(View)
    case path(StackActionOf<Path>)
    case usersList(UserListFeature.Action)
    case updateReachability(isOnline: Bool)
  }

  @CasePathable
  public enum View: BindableAction, Sendable {
    case onAppear
    case binding(BindingAction<State>)
  }

  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.reachabilityClient) var reachabilityClient
  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer(action: \.view)
    Scope(state: \.usersList, action: \.usersList) {
      UserListFeature()
    }
    Reduce { state, action in
      switch action {
      case .view(.onAppear):
        return .run { send in
          for try await networkPath in await reachabilityClient.networkPathPublisher() {
            let isOnline = networkPath.reachability.isOnline
            await send(.updateReachability(isOnline: isOnline), animation: .linear(duration: 0.8))
          }
        }
      case let .updateReachability(isOnline):
        state.showToast = isOnline == false
        return .none
      case .view(.binding):
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
