//
//  DetailTextView.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import SwiftUI

public struct DetailTextView: View {
  let text: String
  public init(_ text: String) {
    self.text = text
  }

  public var body: some View {
    Text(text)
      .accessibilityLabel("Detail text")
      .accessibilityValue(text)
      .font(.system(size: 14))
      .foregroundStyle(Color.text)
  }
}
