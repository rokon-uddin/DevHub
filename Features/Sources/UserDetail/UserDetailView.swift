//
//  UserDetailView.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Common
import ComposableArchitecture
import RepositoryList
import SwiftUI

public struct UserDetailView: View {
  @Perception.Bindable var store: StoreOf<UserDetailFeature>

  public init(store: StoreOf<UserDetailFeature>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        Text(store.name)
          .font(.title3)
          .foregroundStyle(.gray)
        Spacer()
          .frame(height: 24)
        HStack(spacing: 8) {
          Avatar(store.url, size: 120)
          Text(store.bio)
            .foregroundStyle(Color.text)
        }
        .padding(.bottom, 8.0)
        RepositoryListView(
          store: store.scope(state: \.repositoryList, action: \.repositoryList)
        )
        Spacer()
      }
      .padding(4.0)
      .padding(.top, 76)
      .background(Color.background)
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle(store.login)
      .ignoresSafeArea()
      .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
      .onAppear {
        store.send(.onAppear)
      }
      .sheet(
        item: $store.scope(
          state: \.destination?.webView, action: \.destination.webView)
      ) { webStore in
        WebViewNavigationStack(
          store: webStore, title: "ProfileSummary",
          confirmationAction: {
            store.send(.openInSafariTapped(webStore.url))
          },
          cancellationAction: {
            store.send(.closeButtonTapped)
          })
      }
    }
  }
}

extension AlertState where Action == UserDetailFeature.Destination.Alert {
  static func showError(_ error: String) -> Self {
    return AlertState {
      TextState("Error")
    } actions: {
      ButtonState(role: .none, action: .retry) { TextState("Retry") }
      ButtonState(role: .cancel) { TextState("Cancel") }
    } message: {
      TextState(error)
    }
  }
}
