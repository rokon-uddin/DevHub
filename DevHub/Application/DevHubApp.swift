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
  var body: some Scene {
    let store = Store(
      initialState: HomeFeature.State(),
      reducer: { HomeFeature() }
    )

    WindowGroup {
      NavigationStack {
        HomeView(store: store)
      }
      .accentColor(.accent)
    }
  }
}
