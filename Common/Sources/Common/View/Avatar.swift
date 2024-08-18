//
//  Avatar.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import SwiftUI

public struct Avatar: View {
  private let avatarURL: String?
  private let size: CGFloat

  public init(_ avatarURL: String?, size: CGFloat = 80.0) {
    self.avatarURL = avatarURL
    self.size = size
  }

  public var body: some View {
    ImageView()
      .frame(width: size, height: size)
      .cornerRadius(size / 2)
      .addBorder(Color.accent, cornerRadius: size / 2)
  }

  @ViewBuilder
  private func ImageView() -> some View {
    let placeholder = Image(systemName: "person.fill")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundColor(Color.accent)

    if let avatarURL, let url = URL(string: avatarURL) {
      AsyncImage(url: url) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
      } placeholder: {
        placeholder
      }
    } else {
      placeholder
    }
  }
}
