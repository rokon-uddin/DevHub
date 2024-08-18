//
//  WebViewFeature.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import WebKit

@Reducer
public struct WebViewFeature {
  @ObservableState
  public struct State: Equatable {
    public let url: URL
    var isLoading: Bool = false

    public init(url: URL) {
      self.url = url
    }
  }

  public enum Action {
    case isLoading(Bool)
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .isLoading(value):
        state.isLoading = value
        return .none
      }
    }
  }
}

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
