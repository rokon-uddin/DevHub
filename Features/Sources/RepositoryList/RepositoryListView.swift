//
//  RepositoryListView.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Common
import ComposableArchitecture
import Domain
import SwiftUI
import WebKit

public struct RepositoryListView: View {
  @Perception.Bindable var store: StoreOf<RepositoryListFeature>

  public init(store: StoreOf<RepositoryListFeature>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 0) {
      Avatar(store.user.avatarURL, size: 96)
        .padding(.bottom, 8.0)
      if store.isLoading {
        ProgressView()
      }
      ScrollView {
        ForEach(store.repositories) {
          RepositoryCell(model: $0.toViewModel) {

          }
        }
        Spacer()
          .frame(height: 64)
      }
      .scrollIndicators(.hidden)
      .listStyle(.plain)
      .background(Color.background)
      .refreshable {
        //TODO: Implement pull to refresh
      }
    }
    .frame(maxWidth: .infinity)
    .padding(4.0)
    .padding(.top, 88)
    .navigationTitle("Repositories")
    .navigationBarTitleDisplayMode(.inline)
    .background(Color.background)
    .ignoresSafeArea()
    .onAppear {
      store.send(.onAppear)
    }
  }
}
