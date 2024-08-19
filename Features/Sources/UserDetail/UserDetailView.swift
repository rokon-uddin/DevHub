//
//  UserDetailView.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Common
import ComposableArchitecture
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

        HStack {
          CustomButton(title: "Repositories", subTitle: store.publicRepos) {
            store.send(.reposButtonTapped)
          }

          CustomButton(title: "Followers", subTitle: store.followersCount) {}
          CustomButton(title: "Following", subTitle: store.followingCount) {}

        }
        .padding(4.0)

        ScrollView {
          CustomCell(
            title: "Created", detail: store.createdAt, icon: Image.created)
          CustomCell(
            title: "Updated", detail: store.updatedAt, icon: Image.updated)
          CustomCell(title: "Stars", icon: Image.star) {
            //TODO: implement navigation
          }
          CustomCell(title: "Watching", icon: Image.theme) {
            //TODO: implement navigation
          }
          CustomCell(title: "Events", icon: Image.events) {
            //TODO: implement navigation
          }
          CustomCell(title: "Profile Summary", icon: Image.profileSummary) {
            store.send(.profileSummarySelected)
          }
        }
        .padding(.top, 8.0)
        .refreshable {
          //TODO: Implement pull to refresh
        }
      }
      .scrollIndicators(.hidden)
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
