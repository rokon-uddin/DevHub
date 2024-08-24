//
//  UserListSnapshotTests.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/21/24.
//

import ComposableArchitecture
import SnapshotTesting
import SwiftUI
import XCTest

@testable import Domain
@testable import Home
@testable import NetworkPlatform

final class UserListSnapshotTests: XCTestCase {

  @MainActor
  func testResponseFailure() async {
    let users = UsersUseCase(repository: UserListFailingRepository())
    let store = Store(initialState: UserListFeature.State()) {
      UserListFeature()
    } withDependencies: {
      $0.usersClient.githubUsers = users
    }

    store.send(.view(.onAppear))

    let view = UserListView(store: store)
    let vc = UIHostingController(rootView: view)
    store.send(.view(.onAppear))

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
