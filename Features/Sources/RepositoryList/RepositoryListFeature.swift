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
import Utilities

@Reducer
public struct RepositoryListFeature {
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

  public enum Action: ViewAction {
    case view(View)
    case repositoryResponse(Result<RepositoryResponse, Error>)
    case destination(PresentationAction<Destination.Action>)
  }

  @CasePathable
  public enum View: BindableAction, Sendable {
    case onAppear
    case refresh
    case nextPage
    case closeButtonTapped
    case openInSafariTapped(URL)
    case binding(BindingAction<State>)
    case repositorySelected(GitHubRepository)
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.repositoriesClient) var repositoriesClient

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer(action: \.view)
    Reduce { state, action in
      switch action {
      //MARK: View Action
      case .view(.onAppear):
        return githubRepositories(state: &state)
      case .view(.nextPage):
        let canLoadMore = state.repositories.count < state.totalCount
        guard canLoadMore else { return .none }
        state.page += 1
        return githubRepositories(state: &state)
      case .view(.refresh):
        resetPage(state: &state)
        return githubRepositories(state: &state)
      case .view(.closeButtonTapped):
        state.destination = nil
        return .none
      case .view(.repositorySelected(let repo)):
        if let htmlURL = repo.htmlUrl, let url = URL(string: htmlURL) {
          state.destination = .webView(.init(title: htmlURL, url: url))
        }
        return .none
      case .view(.openInSafariTapped(let url)):
        return .run { send in
          await openURL(url)
        }

      case .view(.binding(\.searchText)):
        if state.searchText.isEmpty {
          resetPage(state: &state)
        }
        return githubRepositories(state: &state)
      case .view(.binding):
        return .none

      //MARK: Destination Action
      case let .destination(.presented(.alert(alertAction))):
        switch alertAction {
        case .retry:
          return githubRepositories(state: &state)
        }
      case .destination:
        return .none

      //MARK: Internal Action
      case let .repositoryResponse(.success(response)):
        state.isLoading = false
        state.totalCount = response.totalCount ?? 0
        if let repos = response.items {
          if state.searchText.isEmpty {
            state.repositories.append(contentsOf: repos)
          } else {
            state.repositories = repos
          }
        }
        return .none
      case let .repositoryResponse(.failure(error)):
        state.isLoading = false
        state.destination = .alert(.showError(error.localizedDescription))
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
    state.isLoading = true
    var query: RepositoryQuery {
      let page = state.searchText.isEmpty ? state.page : 1
      return RepositoryQuery(page: page, query: "\(state.searchText) user:\(state.user.login)")
    }

    return .run { [query] send in
      await send(
        .repositoryResponse(
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
