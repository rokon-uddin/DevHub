//
//  UserDetailFeatureTests.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/19/24.
//

import ComposableArchitecture
import XCTest

@testable import Domain
@testable import NetworkPlatform
@testable import UserDetail

final class UserDetailFeatureTests: XCTestCase {

  @MainActor
  func testOnApperSuccess() async {
    let client = UserDetailClient.testValue
    let response = client.userDetail
    let store = TestStore(initialState: UserDetailFeature.State(user: .mock)) {
      UserDetailFeature()
    } withDependencies: {
      $0.userDetailClient.userDetail = response
    }
    await store.send(\.view.onAppear)
    await store.receive(\.userDetailResponse) {
      $0.isLoading = false
      $0.userDetail = Mock.userDetail
    }
  }

  @MainActor
  func testResponseFailure() async {
    let client = UserDetailClient(
      useCase: UserDetailFailingUseCase())
    let response = client.userDetail
    let errorDescription = NetworkRequestError.serverError.localizedDescription
    let store = TestStore(initialState: UserDetailFeature.State(user: .mock)) {
      UserDetailFeature()
    } withDependencies: {
      $0.userDetailClient.userDetail = response
    }
    await store.send(\.view.onAppear)

    await store.receive(\.userDetailResponse.failure) {
      $0.isLoading = false
      $0.destination = .alert(.showError(errorDescription))
    }
  }
}
