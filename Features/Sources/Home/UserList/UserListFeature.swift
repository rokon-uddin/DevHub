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

    var centerLoadingIndicator: Bool {
      isLoading && users.isEmpty
    }

    var bottomLoadingIndicator: Bool {
      isLoading && !users.isEmpty
    }
  }

  public enum Action: ViewAction {
    case view(View)
    case usersResponse(Result<RemoteResponse<Users>?, Error>)
    case destination(PresentationAction<Destination.Action>)
  }

  @CasePathable
  public enum View: Sendable {
    case onAppear
    case nextUsers
    case refresh
  }

  @Dependency(\.usersClient) var usersClient

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      //MARK: View Action
      case .view(.onAppear):
        return githubUsers(state: &state)
      case .view(.nextUsers):
        if !state.isLoading {
          return githubUsers(state: &state)
        }
        return .none
      case .view(.refresh):
        state.nextPage = 0
        state.users = []
        return githubUsers(state: &state)

      //MARK: Destination Action
      case let .destination(.presented(.alert(alertAction))):
        switch alertAction {
        case .retry:
          return githubUsers(state: &state)
        }
      case .destination:
        return .none

      //MARK: Internal Action
      case let .usersResponse(.success(users)):
        state.isLoading = false
        if let users = users?.body {
          state.users.append(contentsOf: users)
        }
        let next = users?.nextPage ?? ""
        state.nextPage = Int.parse(from: next) ?? 0
        return .none
      case let .usersResponse(.failure(error)):
        state.isLoading = false
        state.destination = .alert(.showError(error.localizedDescription))
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
}

extension UserListFeature {
  private func githubUsers(state: inout State) -> Effect<Action> {
    state.isLoading = true
    return .run { [state] send in
      await send(
        .usersResponse(
          Result {
            try await usersClient.githubUsers(input: state.nextPage)
          }))
    }
  }
}
