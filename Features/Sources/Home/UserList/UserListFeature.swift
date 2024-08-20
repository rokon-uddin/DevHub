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
      case retry
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
      case let .usersResponse(.failure(error)):
        let _error = error as? AppError
        let errorString = _error?.errorDescription ?? error.localizedDescription
        state.destination = .alert(.showError(errorString))
        return .none
      case let .destination(.presented(.alert(alertAction))):
        switch alertAction {
        case .retry:
          return githubUsers(state: &state)
        }
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
