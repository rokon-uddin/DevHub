//
//  RepositoryListFeature.swift
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
public struct RepositoryListFeature {
  @Reducer(state: .equatable)
  public enum Destination {
    case webView(WebViewFeature)
    case alert(AlertState<Alert>)

    @CasePathable
    public enum Alert {
      case confirmLoadMockData
    }
  }

  @ObservableState
  public struct State: Equatable {
    @Presents var destination: Destination.State?
    var repositories = [GitHubRepository]()
    var nextPage = 0
    var isLoading = true
    let user: User
    public init(_ user: User) {
      self.user = user
    }
  }

  public enum Action {
    case onAppear
    case closeButtonTapped
    case openInSafariTapped(URL)
    case usersResponse(Result<RepositoryResponse?, Error>)
    case repositorySelected(GitHubRepository)
    case destination(PresentationAction<Destination.Action>)
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.repositoriesClient) var repositoriesClient

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return githubRepositories(state: &state)
      case let .usersResponse(.success(response)):
        if let repos = response?.items {
          state.repositories.append(contentsOf: repos)
        }
        state.isLoading = false
        return .none
      case let .usersResponse(.failure(error)) where error is AppError:
        state.isLoading = false
        Logger.log(logLevel: .error, error)
        return .none
      case let .usersResponse(.failure(error)):
        Logger.log(logLevel: .error, error)
        return .none
      case let .repositorySelected(repo):
        if let htmlURL = repo.htmlUrl, let url = URL(string: htmlURL) {
          state.destination = .webView(WebViewFeature.State(url: url))
        }
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

extension RepositoryListFeature {
  private func githubRepositories(state: inout State) -> Effect<Action> {
    state.isLoading = true
    return .run { [state] send in
      await send(
        .usersResponse(
          Result {
            try await repositoriesClient.githubRepositories(
              input: RepositoryQuery(
                page: 1, sort: "", order: "", query: "user:\(state.user.login)",
                itemPerPage: 30))
          }))
    }
  }
}

extension Int {
  static func parse(from string: String) -> Int? {
    Int(
      string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        .joined())
  }
}
