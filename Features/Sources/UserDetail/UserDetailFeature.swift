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
import RepositoryList
import Utilities

@Reducer
public struct UserDetailFeature {
  @Reducer(state: .equatable)
  public enum Destination {
    case webView(WebViewFeature)
    case alert(AlertState<Alert>)

    @CasePathable
    public enum Alert {
      case retry
    }
  }

  @ObservableState
  public struct State: Equatable {
    @Presents var destination: Destination.State?
    public var user: User
    var isLoading = false
    public var userDetail: UserDetail?
    var repositoryList: RepositoryListFeature.State

    public init(user: User) {
      self.user = user
      self.repositoryList = .init(user)
    }

    public var bio: String { userDetail?.bio ?? "" }
    public var name: String { userDetail?.name ?? "" }
    public var login: String { userDetail?.login ?? "" }
    public var url: String { userDetail?.avatarURL ?? "" }
    public var publicRepos: String { "\(userDetail?.publicRepos ?? 0)" }
    public var followersCount: String { "\(userDetail?.followers ?? 0)" }
    public var followingCount: String { "\(userDetail?.following ?? 0)" }
    public var createdAt: String { userDetail?.createdAt?.timeAgo ?? "" }
    public var updatedAt: String { userDetail?.updatedAt?.timeAgo ?? "" }
  }

  public enum Action {
    case onAppear
    case closeButtonTapped
    case openInSafariTapped(URL)
    case profileSummarySelected
    case repositoryList(RepositoryListFeature.Action)
    case userDetailResponse(Result<UserDetail?, Error>)
    case destination(PresentationAction<Destination.Action>)
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.userDetailClient) var userDetailClient
  public init() {}

  public var body: some ReducerOf<Self> {
    Scope(state: \.repositoryList, action: \.repositoryList) {
      RepositoryListFeature()
    }
    Reduce { state, action in
      switch action {
      case .onAppear:
        return userDetail(state: &state)
      case let .userDetailResponse(.success(response)):
        state.userDetail = response
        state.isLoading = false
        return .none
      case let .userDetailResponse(.failure(error)):
        let _error = error as? AppError
        let errorString = _error?.errorDescription ?? error.localizedDescription
        state.isLoading = false
        state.destination = .alert(.showError(errorString))
        return .none
      case .profileSummarySelected:
        let profileURL =
          "https://profile-summary-for-github.com/user/" + state.user.login
        if let url = URL(string: profileURL) {
          state.destination = .webView(WebViewFeature.State(url: url))
        }
        return .none
      case let .destination(.presented(.alert(alertAction))):
        switch alertAction {
        case .retry:
          return userDetail(state: &state)
        }
      case .repositoryList:
        return .none
      case .destination:
        return .none
      case let .openInSafariTapped(url):
        return .run { send in
          await openURL(url)
        }
      case .closeButtonTapped:
        state.destination = nil
        return .none

      }
    }
    .ifLet(\.$destination, action: \.destination)

  }
}

extension UserDetailFeature {
  private func userDetail(state: inout State) -> Effect<Action> {
    guard !state.isLoading else { return .none }
    state.isLoading = true
    return .run { [state] send in
      await send(
        .userDetailResponse(
          Result {
            try await userDetailClient.userDetail(input: state.user.login)
          }))
    }
  }
}
