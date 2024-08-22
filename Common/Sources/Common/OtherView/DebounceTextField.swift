//
//  DebounceTextField.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/19/24.
//

import SwiftUI

public struct DebouncedTextField: View {
  @Binding private var text: String
  private let placeholder: String
  @OperatorState(.debounce()) private var filterText: String = ""

  public init(placeholder: String = "Search", text: Binding<String>) {
    self._text = text
    self.placeholder = placeholder
  }

  public var body: some View {
    if #available(iOS 17.0, *) {
      TextField(placeholder, text: $filterText)
        .onChange(of: filterText) { self.text = $1 }
        .textFieldStyle(.roundedBorder)
        .accessibilityLabel(placeholder)
        .onAppear {
          UITextField.appearance().clearButtonMode = .whileEditing
        }
    } else {
      TextField("Search", text: $filterText)
        .onChange(of: filterText) { self.text = $0 }
        .textFieldStyle(.roundedBorder)
        .onAppear {
          UITextField.appearance().clearButtonMode = .whileEditing
        }
    }
  }
}
