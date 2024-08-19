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
    var page = 1
    var totalCount = 0
    var isLoading = true
    let user: User
    var searchText = ""
    public init(_ user: User) {
      self.user = user
    }
  }

  public enum Action: BindableAction {
    case onAppear
    case closeButtonTapped
    case openInSafariTapped(URL)
    case nextPage
    case refresh
    case usersResponse(Result<RepositoryResponse, Error>)
    case repositorySelected(GitHubRepository)
    case destination(PresentationAction<Destination.Action>)
    case binding(BindingAction<State>)
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.repositoriesClient) var repositoriesClient

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        return githubRepositories(state: &state)
      case .nextPage:
        guard state.repositories.count < state.totalCount else {
          return .none
        }
        state.page += 1
        return githubRepositories(state: &state)
      case .refresh:
        resetPage(state: &state)
        return githubRepositories(state: &state)
      case let .usersResponse(.success(response)):
        state.totalCount = response.totalCount ?? 0
        if let repos = response.items {
          if state.searchText.isEmpty {
            state.repositories.append(contentsOf: repos)
          } else {
            state.repositories = repos
          }
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
      case .binding(\.searchText):
        if state.searchText.isEmpty {
          resetPage(state: &state)
        }
        return githubRepositories(state: &state)
      case .binding(_):
        return .none
      case .closeButtonTapped:
        state.destination = nil
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
}

extension RepositoryListFeature {

  private func resetPage(state: inout State) {
    state.page = 1
    state.repositories = []
  }

  private func githubRepositories(state: inout State) -> Effect<Action> {
    if state.repositories.isEmpty {
      state.isLoading = true
    }
    var query: RepositoryQuery {
      let page = state.searchText.isEmpty ? state.page : 1
      return RepositoryQuery(page: page, query: "\(state.searchText) user:\(state.user.login)")
    }

    return .run { [query] send in
      await send(
        .usersResponse(
          Result {
            try await repositoriesClient.githubRepositories(input: query)
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
