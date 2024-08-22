//
//  NoSearchResultsView.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/21/24.
//

import SwiftUI

public struct NoSearchResultsView: View {
  private let term: String

  public init(_ term: String) {
    self.term = term
  }

  public var body: some View {
    VStack(spacing: 20) {
      Spacer()
      Image(systemName: "magnifyingglass.circle.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 64, height: 64)
        .foregroundColor(.gray)
        .accessibilityHidden(true)

      Text("No Results Found")
        .font(.title3)
        .foregroundColor(.primary)
        .accessibilityLabel("No search results found")

      Text("We couldn't find any results for \"\(term)\". Please try a different search term.")
        .font(.body)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
      Spacer()
    }
    .padding()
    .accessibilityElement(children: .combine)
    .accessibilityLabel("No results view")
    .accessibilityHint("Try refining your search query")
  }
}
