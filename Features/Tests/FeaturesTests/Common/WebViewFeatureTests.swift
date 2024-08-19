//
//  WebViewFeatureTests.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/19/24.
//

import ComposableArchitecture
import XCTest

@testable import Common

final class WebViewFeatureTests: XCTestCase {

  @MainActor
  func testIsLoading() async {
    let store = TestStore(initialState: WebViewFeature.State(url: URL(string: "url.com")!)) {
      WebViewFeature()
    }

    await store.send(.isLoading(true)) {
      $0.isLoading = true
    }

    await store.send(.isLoading(false)) {
      $0.isLoading = false
    }
  }
}
