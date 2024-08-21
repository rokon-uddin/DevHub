//
//  LoadingIndicator.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/20/24.
//

import SwiftUI

public struct LoadingIndicator: View {
  
  public init() {}
  
  public var body: some View {
    HStack {
      Spacer()
      ProgressView()
      Spacer()
    }
    .background(Color.clear)
  }
}
