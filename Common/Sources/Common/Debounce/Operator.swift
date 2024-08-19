//
//  Operator.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/19/24.
//

import Combine
import Foundation

public protocol Operator {
  associatedtype Value
  func callAsFunction(_ publisher: Published<Value>.Publisher) -> AnyPublisher<Value, Never>
}

public struct DebounceOperator<Value>: Operator {
  let delay: Double
  public func callAsFunction(_ publisher: Published<Value>.Publisher) -> AnyPublisher<Value, Never> {
    publisher.debounce(for: .seconds(delay), scheduler: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

public struct ThrottleOperator<Value>: Operator {
  let delay: Double
  public func callAsFunction(_ publisher: Published<Value>.Publisher) -> AnyPublisher<Value, Never> {
    publisher
      .throttle(for: .seconds(delay), scheduler: RunLoop.main, latest: false)
      .eraseToAnyPublisher()
  }
}

extension Operator {
  public static func throttle<CustomOperator>(delay: Double = 0.3) -> Self
  where Self == ThrottleOperator<CustomOperator> {
    ThrottleOperator(delay: delay)
  }
}

extension Operator {
  public static func debounce<CustomOperator>(delay: Double = 0.3) -> Self
  where Self == DebounceOperator<CustomOperator> {
    DebounceOperator(delay: delay)
  }
}
