//
//  HomeView.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Common
import ComposableArchitecture
import Domain
import RepositoryList
import SwiftUI
import UserDetail

@MainActor
public struct HomeView: View {
  @Perception.Bindable var store: StoreOf<HomeFeature>

  public init(store: StoreOf<HomeFeature>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      UserListView(
        store: store.scope(state: \.usersList, action: \.usersList)
      )
    } destination: { store in
      switch store.case {
      case let .detail(store):
        UserDetailView(store: store)
          .toolbarRole(.editor)
      case let .repos(store):
        RepositoryListView(store: store)
          .toolbarRole(.editor)
      }
    }
  }
}
