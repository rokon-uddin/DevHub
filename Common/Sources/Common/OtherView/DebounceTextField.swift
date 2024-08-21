//
//  DebounceTextField.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/19/24.
//

import SwiftUI

public struct DebouncedTextField: View {
  @Binding private var text: String
  @OperatorState(.debounce()) private var filterText: String = ""

  public init(text: Binding<String>) {
    self._text = text
  }

  public var body: some View {
    if #available(iOS 17.0, *) {
      TextField("Search", text: $filterText)
        .onChange(of: filterText) { self.text = $1 }
        .textFieldStyle(.roundedBorder)
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
