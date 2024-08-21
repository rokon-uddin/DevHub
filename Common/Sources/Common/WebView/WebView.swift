//
//  WebView.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import WebKit

public struct WebView: View {
  @Perception.Bindable var store: StoreOf<WebViewFeature>

  public init(store: StoreOf<WebViewFeature>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      WebViewRepresentable(
        url: store.url, isLoading: $store.isLoading.sending(\.isLoading)
      )
      .overlay {
        if store.isLoading {
          ProgressView()
            .frame(alignment: .center)
        }
      }
    }
  }
}

private struct WebViewRepresentable: UIViewRepresentable {
  private let url: URL
  private var isLoading: Binding<Bool>

  init(url: URL, isLoading: Binding<Bool>) {
    self.url = url
    self.isLoading = isLoading
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(isLoading: isLoading)
  }

  func makeUIView(context: Context) -> WKWebView {
    let wkwebView = WKWebView()
    wkwebView.navigationDelegate = context.coordinator
    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
    wkwebView.load(request)
    return wkwebView
  }

  func updateUIView(_ uiView: WKWebView, context: Context) {}

  class Coordinator: NSObject, WKNavigationDelegate {
    private var isLoading: Binding<Bool>

    init(isLoading: Binding<Bool>) {
      self.isLoading = isLoading
    }

    func webView(
      _ webView: WKWebView,
      didStartProvisionalNavigation navigation: WKNavigation!
    ) {
      isLoading.wrappedValue = true
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      isLoading.wrappedValue = false
    }

    func webView(
      _ webView: WKWebView,
      didFailProvisionalNavigation navigation: WKNavigation!,
      withError error: Error
    ) {
      isLoading.wrappedValue = false
    }
  }
}

public struct WebViewNavigationStack: View {

  private let title: String
  private var confirmationAction: () -> Void
  private var cancellationAction: () -> Void
  @Perception.Bindable private var store: StoreOf<WebViewFeature>

  public init(
    store: StoreOf<WebViewFeature>,
    title: String,
    confirmationAction: @escaping () -> Void,
    cancellationAction: @escaping () -> Void
  ) {
    self.title = title
    self.confirmationAction = confirmationAction
    self.cancellationAction = cancellationAction
    self.store = store
  }

  public var body: some View {
    NavigationStack {
      WebView(store: store)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .confirmationAction) {
            Button {
              confirmationAction()
            } label: {
              Icon.safari
            }
            .accentColor(.accent)
          }
          ToolbarItem(placement: .cancellationAction) {
            Button {
              cancellationAction()
            } label: {
              Icon.xmarkCircle
            }
            .accentColor(.accent)
          }
        }
    }
  }
}
