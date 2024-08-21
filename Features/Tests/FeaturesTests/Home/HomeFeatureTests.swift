//
//  HomeFeatureTests.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/21/24.
//

import ComposableArchitecture
import XCTest

@testable import Domain
@testable import Home
@testable import NetworkPlatform
@testable import Reachability

final class HomeFeatureTests: XCTestCase {
  
  @MainActor
    func testOnApperFailure() async {
      let client = ReachabilityClient.unsatisfied
      let response = await client.networkPathPublisher()
      let store = TestStore(initialState: HomeFeature.State()) {
        HomeFeature()
      } withDependencies: {
        $0.reachabilityClient.networkPathPublisher = { response }
      }
      await store.send(.onAppear)
      await store.receive(\.updateReachability) {
        $0.showToast = true
      }
    }
}
