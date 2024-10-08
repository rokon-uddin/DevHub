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

@ViewAction(for: RepositoryListFeature.self)
public struct RepositoryListView: View {
  @Perception.Bindable public var store: StoreOf<RepositoryListFeature>

  public init(store: StoreOf<RepositoryListFeature>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        DebouncedTextField(text: $store.searchText)
          .padding(.bottom, 4)
          .padding([.leading, .trailing], 8)
        ZStack(alignment: .bottom) {
          if store.centerLoadingIndicator {
            ProgressView()
          } else if store.noSearchResults {
            NoSearchResultsView(store.searchText)
          } else {
            List {
              ForEach(store.repositories) { repo in
                WithPerceptionTracking {
                  RepositoryCell(model: repo.toViewModel) {
                    send(.repositorySelected(repo))
                  }
                  .accessibilityElement(children: .combine)
                  .accessibilityHint("Tap to view details for \(repo.name)")
                  .accessibilityIdentifierBranch("RepositoryCell")
                  .onAppear {
                    if repo == store.repositories.last {
                      send(.nextPage)
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

              Spacer()
                .listRowBackground(Color.background)
                .listRowSeparator(.hidden)
            }
            .background(Color.background)
            .scrollIndicators(.hidden)
            .listStyle(.plain)
            .refreshable { send(.refresh) }
          }

          if store.bottomLoadingIndicator {
            LoadingIndicator()
              .padding(.bottom, 24)
          }
        }
      }
      .frame(maxWidth: .infinity)
      .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
      .onAppear {
        send(.onAppear)
      }
      .sheet(
        item: $store.scope(
          state: \.destination?.webView, action: \.destination.webView)
      ) { webStore in
        WithPerceptionTracking {
          WebViewNavigationStack(
            store: webStore, title: webStore.url.absoluteString,
            confirmationAction: {
              send(.openInSafariTapped(webStore.url))
            },
            cancellationAction: {
              send(.closeButtonTapped)
            })
        }
      }
    }
  }
}

extension AlertState where Action == RepositoryListFeature.Destination.Alert {
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
