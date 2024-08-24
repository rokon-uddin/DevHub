//
//  RepositoryListSnapshotTests.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/21/24.
//

import ComposableArchitecture
import SnapshotTesting
import SwiftUI
import XCTest

@testable import Domain
@testable import NetworkPlatform
@testable import RepositoryList

final class RepositoryListSnapshotTests: XCTestCase {

  @MainActor
  func testOnApperSuccess() async {
    let client = RepositoryClient.testValue
    let response = client.githubRepositories
    let store = Store(initialState: RepositoryListFeature.State(.mock)) {
      RepositoryListFeature()
    } withDependencies: {
      $0.repositoriesClient.githubRepositories = response
    }

    store.send(.view(.onAppear))

    let view = RepositoryListView(store: store)
    let vc = UIHostingController(rootView: view)

    let expectation = self.expectation(description: "expectation")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      expectation.fulfill()
    }
    await fulfillment(of: [expectation])

    withSnapshotTesting {
      assertSnapshot(of: vc, as: .image(on: .iPhoneSe))
      assertSnapshot(of: vc, as: .image(on: .iPhone13))
      assertSnapshot(of: vc, as: .image(on: .iPhone13ProMax))
      assertSnapshot(of: vc, as: .image(on: .iPadPro12_9))
      assertSnapshot(of: vc, as: .image(on: .iPadPro12_9(.landscape(splitView: .oneThird))))
    }
  }

  @MainActor
  func testResponseFailure() async {
    let repositories = RepositoryUseCase(repository: GitRepoRepositoryFailingRepository())
    let store = Store(initialState: RepositoryListFeature.State(.mock)) {
      RepositoryListFeature()
    } withDependencies: {
      $0.repositoriesClient.githubRepositories = repositories
    }

    store.send(.view(.onAppear))

    let view = RepositoryListView(store: store)
    let vc = UIHostingController(rootView: view)

    let expectation = self.expectation(description: "expectation")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      expectation.fulfill()
    }
    await fulfillment(of: [expectation])

    withSnapshotTesting {
      assertSnapshot(of: vc, as: .image(on: .iPhoneSe))
      assertSnapshot(of: vc, as: .image(on: .iPhone13))
      assertSnapshot(of: vc, as: .image(on: .iPhone13ProMax))
      assertSnapshot(of: vc, as: .image(on: .iPadPro12_9))
      assertSnapshot(of: vc, as: .image(on: .iPadPro12_9(.landscape(splitView: .oneThird))))
    }
  }
}
