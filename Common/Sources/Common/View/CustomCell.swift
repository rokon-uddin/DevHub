//
//  CustomCell.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import SwiftUI

public struct CustomCell: View {
  let title: String
  let detail: String?
  let icon: Image
  var action: (() -> Void)?

  public init(
    title: String,
    detail: String? = nil,
    icon: Image,
    action: (() -> Void)? = nil
  ) {
    self.title = title
    self.detail = detail
    self.icon = icon
    self.action = action
  }

  public var body: some View {
    Button(
      action: { action?() },
      label: {
        HStack {
          icon
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)
            .accentColor(.accent)
          Text(title)
            .foregroundStyle(Color.text)
          Spacer()

          if let detail { DetailTextView(detail) }
          if action != nil { Icon.arrow }
        }
        .frame(height: 48)
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing], 8.0)
      }
    )
    .background(Color.foreground)
    .cornerRadius(8.0)
  }
}
