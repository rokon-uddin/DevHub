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
      .addBorder(Color.black, cornerRadius: size / 2)
  }

  @ViewBuilder
  private func ImageView() -> some View {
    if let avatarURL, let url = URL(string: avatarURL) {
      AsyncImage(url: url) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
      } placeholder: {
        ProgressView()
      }
    } else {
      Image(systemName: "person")
    }
  }
}

extension View {
  public func addBorder<S>(
    _ content: S, width: CGFloat = 1, cornerRadius: CGFloat
  ) -> some View where S: ShapeStyle {
    let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
    return clipShape(roundedRect)
      .overlay(roundedRect.strokeBorder(content, lineWidth: width))
  }
}
