//
//  RepositoryListFeatureTests.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/21/24.
//

import ComposableArchitecture
import XCTest

@testable import Domain
@testable import NetworkPlatform
@testable import RepositoryList

final class RepositoryListTests: XCTestCase {

  @MainActor
  func testOnApperSuccess() async {
    let client = RepositoryClient.testValue
    let response = client.githubRepositories
    let store = TestStore(initialState: RepositoryListFeature.State(.mock)) {
      RepositoryListFeature()
    } withDependencies: {
      $0.repositoriesClient.githubRepositories = response
    }

    let repos = Mock.repositories
    await store.send(\.view.onAppear)
    await store.receive(\.repositoryResponse) {
      $0.isLoading = false
      $0.totalCount = repos.totalCount ?? 0
      $0.repositories = repos.items ?? []
    }
  }

  @MainActor
  func testLoadMoreSuccess() async {
    let client = RepositoryClient.testValue
    let response = client.githubRepositories
    let store = TestStore(initialState: RepositoryListFeature.State(.mock)) {
      RepositoryListFeature()
    } withDependencies: {
      $0.repositoriesClient.githubRepositories = response
    }

    let repos = Mock.repositories
    await store.send(\.view.onAppear)
    await store.receive(\.repositoryResponse) {
      $0.isLoading = false
      $0.totalCount = repos.totalCount ?? 0
      $0.repositories = repos.items ?? []
    }

    await store.send(\.view.nextPage) {
      $0.page += 1
      $0.isLoading = true
    }

    let reposNext = Mock.nextRepositories
    await store.receive(\.repositoryResponse) {
      $0.isLoading = false
      $0.totalCount = reposNext.totalCount ?? 0
      $0.repositories.append(contentsOf: reposNext.items ?? [])
    }
  }

  @MainActor
  func testResponseFailure() async {
    let repositories = RepositoryUseCase(repository: GitRepoRepositoryFailingRepository())
    let errorDescription = NetworkRequestError.serverError.localizedDescription
    let store = TestStore(initialState: RepositoryListFeature.State(.mock)) {
      RepositoryListFeature()
    } withDependencies: {
      $0.repositoriesClient.githubRepositories = repositories
    }

    await store.send(\.view.onAppear)

    await store.receive(\.repositoryResponse.failure) {
      $0.isLoading = false
      $0.destination = .alert(.showError(errorDescription))
    }
  }

  @MainActor
  func testSearchRepoAvailable() async {
    let client = RepositoryClient.testValue
    let response = client.githubRepositories
    let store = TestStore(initialState: RepositoryListFeature.State(.mock)) {
      RepositoryListFeature()
    } withDependencies: {
      $0.repositoriesClient.githubRepositories = response
    }

    let repos = Mock.repositories
    await store.send(\.view.onAppear)
    await store.receive(\.repositoryResponse) {
      $0.isLoading = false
      $0.totalCount = repos.totalCount ?? 0
      $0.repositories = repos.items ?? []
    }

    await store.send(\.view.binding.searchText, "javascript-decorators") {
      $0.searchText = "javascript-decorators"
      $0.isLoading = true
    }

    let searchRepos = Mock.searchRepositories
    await store.receive(\.repositoryResponse) {
      $0.isLoading = false
      $0.totalCount = searchRepos.totalCount ?? 0
      $0.repositories = searchRepos.items ?? []
    }
  }
}
