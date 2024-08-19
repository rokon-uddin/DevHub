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
          NavigationLink(
            state: HomeFeature.Path.State.detail(UserDetailFeature.State(user))
          ) {
            UserCard(user)
              .onAppear {
                if user == store.users.last {
                  store.send(.nextUsers)
                }
              }
          }
        }
      }
      .refreshable {
        //TODO: Implement pull to refresh
      }
      .listStyle(.plain)
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
    }
  }
}
