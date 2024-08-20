//
//  HomeFeature.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Common
import ComposableArchitecture
import Domain
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

    public init() {}
  }

  public enum Action {
    case path(StackActionOf<Path>)
    case usersList(UserListFeature.Action)
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Scope(state: \.usersList, action: \.usersList) {
      UserListFeature()
    }
    Reduce { state, action in
      switch action {
      case .usersList:
        return .none
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}
