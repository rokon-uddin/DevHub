//
//  ParentAccessibilityBranchKey.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/22/24.
//

import SwiftUI

struct ParentAccessibilityBranchKey: EnvironmentKey {
  static let defaultValue: String? = nil
}

extension EnvironmentValues {
  var parentAccessibilityBranch: String? {
    get { self[ParentAccessibilityBranchKey.self] }
    set { self[ParentAccessibilityBranchKey.self] = newValue }
  }
}
