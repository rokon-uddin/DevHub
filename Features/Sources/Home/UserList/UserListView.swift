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

public struct UserListView: View {
  @Perception.Bindable var store: StoreOf<UserListFeature>

  public init(store: StoreOf<UserListFeature>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      List {
        ForEach(store.users) { user in
          NavigationLink(state: HomeFeature.Path.State.detail(UserDetailFeature.State(user: user))) {
            UserCard(user)
              .onAppear {
                if user == store.users.last {
                  store.send(.nextUsers)
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
      .background(Color.background)
      .listStyle(.plain)
      .scrollIndicators(.hidden)
      .refreshable {
        //TODO: Implement pull to refresh
      }
      .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
      .navigationTitle("Developers")
      .onAppear {
        store.send(.onAppear)
      }
    }
  }
  private func UserCard(_ user: User) -> some View {
    return HStack(alignment: .center, spacing: 16) {
      Avatar(user.avatarURL)
      Text(user.login)
        .font(.title2)
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
