//
//  CustomButton.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import SwiftUI

public struct CustomButton: View {
  private var title: String
  var action: () -> Void

  public init(title: String, action: @escaping () -> Void) {
    self.title = title
    self.action = action
  }

  public var body: some View {
    Button(
      action: action,
      label: {
        ZStack {
          Color.accent
          VStack {
            Text(title)
              .font(.system(size: 14))
              .fontWeight(.semibold)
              .foregroundStyle(.white)
              .accessibilityLabel(title)
              .accessibilityHint("Tap to perform the action")
          }
        }
      }
    )
    .cornerRadius(8.0)
    .frame(height: 40)
  }
}
