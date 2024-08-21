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
    public let title: String
    public let url: URL
    var isLoading: Bool = false

    public init(title: String, url: URL) {
      self.title = title
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
