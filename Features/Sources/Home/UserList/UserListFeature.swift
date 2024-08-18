//
//  UserListFeature.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Common
import ComposableArchitecture
import Domain
import Foundation
import UserDetail
import Utilities

@Reducer
public struct UserListFeature {
  @Reducer(state: .equatable)
  public enum Destination {
    case detail(UserDetailFeature)
    case alert(AlertState<Alert>)

    @CasePathable
    public enum Alert {
      case confirmLoadMockData
    }
  }

  @ObservableState
  public struct State: Equatable {
    @Presents var destination: Destination.State?
    var users: Users = []
    var nextPage = 0
    var isLoading = true

    public init() {}
  }

  public enum Action {
    case onAppear
    case nextUsers
    case usersResponse(Result<RemoteResponse<Users>?, Error>)
    case userSelected
    case destination(PresentationAction<Destination.Action>)
  }

  @Dependency(\.usersClient) var usersClient

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return githubUsers(state: &state)
      case .nextUsers:
        if !state.isLoading {
          return githubUsers(state: &state)
        }
        return .none
      case let .usersResponse(.success(users)):
        if let users = users?.body {
          state.users.append(contentsOf: users)
        }
        let next = users?.nextPage ?? ""
        state.nextPage = Int.parse(from: next) ?? 0
        state.isLoading = false
        return .none
      case let .usersResponse(.failure(error)) where error is AppError:
        Logger.log(logLevel: .error, error)
        return .none
      case let .usersResponse(.failure(error)):
        Logger.log(logLevel: .error, error)
        return .none
      case .userSelected:
        state.destination = .detail(
          UserDetailFeature.State(state.users.first!)
        )
        return .none
      case .destination:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
}

extension UserListFeature {
  private func githubUsers(state: inout State) -> Effect<Action> {
    return .run { [state] send in
      await send(
        .usersResponse(
          Result {
            try await usersClient.githubUsers(input: state.nextPage)
          }))
    }
  }
}
