//
//  UseCase.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

public protocol UseCase<Input, Output> {
  associatedtype Input
  associatedtype Output

  func callAsFunction(input: Input) async throws -> Output
}

extension UseCase where Input == Void {
  public func callAsFunction() async throws -> Output {
    try await callAsFunction(input: ())
  }
}
