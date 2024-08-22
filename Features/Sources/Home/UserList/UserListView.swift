//
//  UserListView.swift
//
//
//  Created by Mohammed Rokon Uddin on 8/16/24.
//
//

import Common
import ComposableArchitecture
import Domain
import SwiftUI
import UserDetail
import WebKit

@ViewAction(for: UserListFeature.self)
public struct UserListView: View {
  @Perception.Bindable public var store: StoreOf<UserListFeature>

  public init(store: StoreOf<UserListFeature>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      ZStack(alignment: .bottom) {
        if store.centerLoadingIndicator {
          ZStack {
            Color.background
            ProgressView()
          }
          .ignoresSafeArea()
        } else {
          List {
            ForEach(store.users) { user in
              NavigationLink(state: HomeFeature.Path.State.detail(UserDetailFeature.State(user: user))) {
                UserCard(user)
                  .onAppear {
                    if user == store.users.last {
                      send(.nextUsers)
                    }
                  }
              }
            }
            .listRowBackground(
              RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color.foreground)
                .padding(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8))
            )
            .listRowSeparator(.hidden)
          }
          .accessibilityLabel("Github User list")
          .accessibilityHint("Select row to see detail")
          .background(Color.background)
          .listStyle(.plain)
          .scrollIndicators(.hidden)
          .refreshable { send(.refresh) }
          .navigationTitle("Developers")
        }

        if store.bottomLoadingIndicator {
          LoadingIndicator()
        }
      }
      .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
    .onAppear { send(.onAppear) }
  }
  private func UserCard(_ user: User) -> some View {
    return HStack(alignment: .center, spacing: 16) {
      Avatar(user.avatarURL)
        .accessibilityHidden(true)
      Text(user.login)
        .font(.title2)
        .accessibilityLabel("Username")
        .accessibilityValue(user.login)
      Spacer()
    }
  }
}

extension AlertState where Action == UserListFeature.Destination.Alert {
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
