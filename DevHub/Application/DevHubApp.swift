//
//  DevHubApp.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Common
import ComposableArchitecture
import Home
import Reachability
import SwiftUI

@main
struct DevHubApp: App {
  @MainActor
  static let store = Store(
    initialState: HomeFeature.State(),
    reducer: { HomeFeature() }
  )
  @State var showToast = false
  @Dependency(\.reachabilityClient) var reachabilityClient

  var body: some Scene {
    WindowGroup {
      if _XCTIsTesting {
        // NB: Don't run application in tests to avoid interference between the app and the test.
        EmptyView()
      } else {
        ZStack(alignment: .bottom) {
          HomeView(store: Self.store)
            .accentColor(.accent)
          Rectangle()
            .fill(.clear)
            .background(.clear)
            .frame(height: 36)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())  // Ensure it has a tappable shape
            .allowsHitTesting(false)
            .toast(toast: .networkError(show: $showToast), show: $showToast)
            .task {
              for await networkPath in await reachabilityClient.networkPathPublisher() {
                let isOnline = networkPath.reachability.isOnline
                if !isOnline {
                  withAnimation {
                    showToast = true
                  }
                }
              }
            }
        }
      }
    }
  }
}
