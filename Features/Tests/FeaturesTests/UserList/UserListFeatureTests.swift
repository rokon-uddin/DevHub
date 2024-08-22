//
//  UserListFeatureTests.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/21/24.
//

import ComposableArchitecture
import XCTest

@testable import Domain
@testable import Home
@testable import NetworkPlatform

final class UserListFeatureTests: XCTestCase {

  @MainActor
  func testOnApperSuccess() async {
    let client = UsersClient.testValue
    let response = client.githubUsers
    let store = TestStore(initialState: UserListFeature.State()) {
      UserListFeature()
    } withDependencies: {
      $0.usersClient.githubUsers = response
    }
    await store.send(\.view.onAppear)
    await store.receive(\.usersResponse) {
      $0.isLoading = false
      $0.users = Mock.users
    }
  }

  @MainActor
  func testLoadMoreSuccess() async {
    let client = UsersClient.testValue
    let response = client.githubUsers
    let store = TestStore(initialState: UserListFeature.State()) {
      UserListFeature()
    } withDependencies: {
      $0.usersClient.githubUsers = response
    }
    await store.send(\.view.onAppear)
    await store.receive(\.usersResponse.success) {
      $0.isLoading = false
      $0.users.append(contentsOf: Mock.users)
    }

    await store.send(\.view.nextUsers) {
      $0.isLoading = true
    }

    await store.receive(\.usersResponse.success) {
      $0.isLoading = false
      $0.users.append(contentsOf: Mock.users)
    }
  }

  @MainActor
  func testRefreshSuccess() async {
    let client = UsersClient.testValue
    let response = client.githubUsers
    let store = TestStore(initialState: UserListFeature.State()) {
      UserListFeature()
    } withDependencies: {
      $0.usersClient.githubUsers = response
    }
    await store.send(\.view.onAppear)
    await store.receive(\.usersResponse.success) {
      $0.isLoading = false
      $0.users.append(contentsOf: Mock.users)
    }

    await store.send(\.view.refresh) {
      $0.nextPage = 0
      $0.users = []
      $0.isLoading = true
    }

    await store.receive(\.usersResponse.success) {
      $0.isLoading = false
      $0.users.append(contentsOf: Mock.users)
    }
  }

  @MainActor
  func testResponseFailure() async {
    let client = UsersClient(usersUseCase: UserListFailingUseCase())
    let response = client.githubUsers
    let errorDescription = NetworkRequestError.serverError.localizedDescription

    let store = TestStore(initialState: UserListFeature.State()) {
      UserListFeature()
    } withDependencies: {
      $0.usersClient.githubUsers = response
    }

    await store.send(\.view.onAppear)
    await store.receive(\.usersResponse.failure) {
      $0.isLoading = false
      $0.destination = .alert(.showError(errorDescription))
    }
  }
}
