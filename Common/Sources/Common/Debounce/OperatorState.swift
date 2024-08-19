//
//  OperatorState.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/19/24.
//

import Combine
import SwiftUI

@propertyWrapper
public struct OperatorState<CustomOperator: Operator>: DynamicProperty {

  @StateObject var state: OperatingState

  public init(initialValue: CustomOperator.Value, _ operate: CustomOperator) {
    self.init(wrappedValue: initialValue, operate)
  }

  public init(wrappedValue: CustomOperator.Value, _ operate: CustomOperator) {
    let state = OperatingState(initialValue: wrappedValue, operate)
    self._state = StateObject(wrappedValue: state)
  }

  class OperatingState: ObservableObject {
    @Published var currentValue: CustomOperator.Value
    @Published var operatedValue: CustomOperator.Value

    init(initialValue: CustomOperator.Value, _ operate: CustomOperator) {
      _currentValue = Published(initialValue: initialValue)
      _operatedValue = Published(initialValue: initialValue)

      operate($currentValue)
        .assign(to: &$operatedValue)
    }
  }

  public var wrappedValue: CustomOperator.Value {
    get { state.operatedValue }
    set { state.currentValue = newValue }
  }

  public var projectedValue: Binding<CustomOperator.Value> {
    $state.currentValue
  }
}
