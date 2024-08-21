//
//  UserDetailSnapshotTests.swift
//
//
//  Created by Mohammed Rokon Uddin on 8/21/24.
//

import ComposableArchitecture
import SnapshotTesting
import SwiftUI
import XCTest

@testable import Domain
@testable import NetworkPlatform
@testable import UserDetail

final class UserDetailSnapshotTests: XCTestCase {

  @MainActor
  func testOnApperSuccess() async {
    let client = UserDetailClient.testValue
    let response = client.userDetail
    let store = Store(initialState: UserDetailFeature.State(user: .mock)) {
      UserDetailFeature()
    } withDependencies: {
      $0.userDetailClient.userDetail = response
    }

    let view = UserDetailView(store: store)
    let vc = UIHostingController(rootView: view)
    store.send(.onAppear)

    let expectation = self.expectation(description: "wait")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
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
    let client = UserDetailClient(
      useCase: UserDetailFailingUseCase())
    let response = client.userDetail
    let store = Store(initialState: UserDetailFeature.State(user: .mock)) {
      UserDetailFeature()
    } withDependencies: {
      $0.userDetailClient.userDetail = response
    }

    let view = UserDetailView(store: store)
    let vc = UIHostingController(rootView: view)
    store.send(.onAppear)

    let expectation = self.expectation(description: "wait")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
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
