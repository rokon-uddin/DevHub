//
//  CustomButton.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import SwiftUI

public struct CustomButton: View {
  private var title: String
  private var subTitle: String
  var action: () -> Void

  public init(title: String, subTitle: String, action: @escaping () -> Void) {
    self.title = title
    self.subTitle = subTitle
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
            Text(subTitle)
              .fontWeight(.bold)
              .foregroundStyle(.white)
          }
        }
      }
    )
    .cornerRadius(8.0)
    .frame(height: 48)
  }
}
