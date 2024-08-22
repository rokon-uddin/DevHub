//
//  View+Extension.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import SwiftUI

extension View {
  public func addBorder<S>(
    _ content: S, width: CGFloat = 1, cornerRadius: CGFloat
  ) -> some View where S: ShapeStyle {
    let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
    return clipShape(roundedRect)
      .overlay(roundedRect.strokeBorder(content, lineWidth: width))
  }
}
