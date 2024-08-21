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

    await store.send(.onAppear)
    await store.receive(\.repositoryResponse) {
      $0.isLoading = false
      $0.totalCount = mockSearchResponse.totalCount ?? 0
      $0.repositories = mockSearchResponse.items
      $0.repositories = mockSearchResponse.items
    }
  }

  @MainActor
  func testResponseFailure() async {
    let client = RepositoryClient(
      useCase: RepositoryFailingUseCase())
    let response = client.githubRepositories
    let errorDescription = NetworkRequestError.serverError.localizedDescription
    let store = TestStore(initialState: RepositoryListFeature.State(.mock)) {
      RepositoryListFeature()
    } withDependencies: {
      $0.repositoriesClient.githubRepositories = response
    }

    await store.send(.onAppear)

    await store.receive(\.repositoryResponse.failure) {
      $0.isLoading = false
      $0.destination = .alert(.showError(errorDescription))
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

    await store.send(.onAppear)
    await store.receive(\.repositoryResponse) {
      $0.isLoading = false
      $0.totalCount = mockSearchResponse.totalCount ?? 0
      $0.repositories = mockSearchResponse.items
    }

    await store.send(.nextPage) {
      $0.page += 1
      $0.isLoading = true
    }

    await store.receive(\.repositoryResponse) {
      $0.isLoading = false
      $0.totalCount = mockSearchResponse.totalCount ?? 0
      $0.repositories.append(contentsOf: mockSearchResponseNext.items)
    }
  }
}
