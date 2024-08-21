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

@ViewAction(for: UserDetailFeature.self)
public struct UserDetailView: View {
  @Perception.Bindable public var store: StoreOf<UserDetailFeature>

  public init(store: StoreOf<UserDetailFeature>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        HeaderView()
          .frame(maxWidth: .infinity)
          .frame(height: 248)
        RepositoryListView(
          store: store.scope(state: \.repositoryList, action: \.repositoryList)
        )
        Spacer()
      }
      .frame(maxWidth: .infinity)
      .padding(4.0)
      .padding(.top, 76)
      .ignoresSafeArea()
      .background(Color.background)
      .navigationTitle(store.login)
      .navigationBarTitleDisplayMode(.inline)
      .onAppear { send(.onAppear) }
      .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
      .sheet(
        item: $store.scope(
          state: \.destination?.webView, action: \.destination.webView)
      ) { webStore in
        WebViewNavigationStack(
          store: webStore, title: webStore.title,
          confirmationAction: { send(.openInSafariTapped(webStore.url)) },
          cancellationAction: { send(.closeButtonTapped) })
      }
    }
  }

  func HeaderView() -> some View {
    VStack(spacing: 0) {
      Text(store.name)
        .padding(.top, 4.0)
        .font(.title3)
        .foregroundStyle(.gray)
      FollowersAndFollowingView()
        .frame(maxWidth: .infinity)
      Spacer()
      HStack(spacing: 8) {
        Avatar(store.url, size: 120)
        Text(store.bio)
          .foregroundStyle(Color.text)
      }
      
      CustomButton(title: "Profile Summary") {
        send(.profileSummarySelected)
      }
      .padding(8)
    }
  }

  func FollowersAndFollowingView() -> some View {
    HStack {
      Spacer()
        .overlay {
          HStack {
            Spacer()
            Text("Followers")
              .font(.system(size: 14))
              .fontWeight(.semibold)
              .foregroundStyle(Color.accent)
            Text(store.followersCount)
              .fontWeight(.bold)
              .foregroundStyle(Color.accent)
          }
        }
      Text("|")
        .padding([.leading, .trailing], 8)
        .fontWeight(.heavy)
        .font(.system(size: 16))
        .foregroundStyle(Color.accent)
      Spacer()
        .overlay {
          HStack {
            Text(store.followingCount)
              .fontWeight(.bold)
              .foregroundStyle(Color.accent)
            Text("Following")
              .font(.system(size: 14))
              .fontWeight(.semibold)
              .foregroundStyle(Color.accent)
            Spacer()
          }

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
