//
//  DevHubApp.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import ComposableArchitecture
import Home
import SwiftUI

@main
struct DevHubApp: App {
  @MainActor
  static let store = Store(
    initialState: HomeFeature.State(),
    reducer: { HomeFeature() }
  )
  var body: some Scene {
    WindowGroup {
      if _XCTIsTesting {
        // NB: Don't run application in tests to avoid interference between the app and the test.
        EmptyView()
      } else {
        HomeView(store: Self.store)
          .accentColor(.accent)
      }

    }
  }
}
