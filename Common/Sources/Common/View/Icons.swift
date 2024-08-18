//
//  Icons.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import SwiftUI

public struct Icon: View {
  let name: String
  let size: CGSize
  let color: Color

  public init(
    name: String, size: CGSize = .init(width: 16, height: 16),
    color: Color = Color.accent
  ) {
    self.name = name
    self.size = size
    self.color = color
  }
  public var body: some View {
    Image(systemName: name)
      .resizable()
      .tint(color)
      .frame(width: size.width, height: size.height)
  }
}

extension Icon {
  public static let starFill = Icon(name: "star.fill")
  public static let eyeFill = Icon(
    name: "eye.fill", size: .init(width: 20, height: 16))
  public static let arrow = Icon(
    name: "greaterthan", size: .init(width: 8, height: 16))
}
