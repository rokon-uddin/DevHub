//
//  UserDetailFeature.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Common
import ComposableArchitecture
import Domain
import Foundation
import Utilities

@Reducer
public struct UserDetailFeature {
  @ObservableState
  public struct State: Equatable {
    public var user: User
    var isLoading = true
    public var userDetail: UserDetail?

    public init(_ user: User) {
      self.user = user
    }

    public var bio: String { userDetail?.bio ?? "" }
    public var name: String { userDetail?.name ?? "" }
    public var login: String { userDetail?.login ?? "" }
    public var url: String { userDetail?.avatarURL ?? "" }
    public var publicRepos: String { "\(userDetail?.publicRepos ?? 0)" }
    public var followersCount: String { "\(userDetail?.followers ?? 0)" }
    public var followingCount: String { "\(userDetail?.followers ?? 0)" }
    public var createdAt: String { userDetail?.createdAt?.timeAgo ?? "" }
    public var updatedAt: String { userDetail?.createdAt?.timeAgo ?? "" }
  }

  public enum Action {
    case onAppear
    case userDetailResponse(Result<UserDetail?, Error>)
    case delegate(Delegate)
    case reposButtonTapped
  }

  @CasePathable
  public enum Delegate {
    case repositories(User)
  }

  @Dependency(\.userDetailClient) var userDetailClient
  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return userDetail(state: &state)
      case let .userDetailResponse(.success(response)):
        state.userDetail = response
        state.isLoading = false
        return .none
      case let .userDetailResponse(.failure(error)) where error is AppError:
        Logger.log(logLevel: .error, error)
        return .none
      case let .userDetailResponse(.failure(error)):
        Logger.log(logLevel: .error, error)
        return .none
      case .reposButtonTapped:
        return .send(.delegate(.repositories(state.user)))
      case .delegate:
        return .none
      }
    }
  }
}

extension UserDetailFeature {
  private func userDetail(state: inout State) -> Effect<Action> {
    return .run { [state] send in
      await send(
        .userDetailResponse(
          Result {
            try await userDetailClient.userDetail(input: state.user.login)
          }))
    }
  }
}
