//
//  AlwaysFailingUseCase.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/19/24.
//

@testable import Domain
@testable import NetworkPlatform
@testable import UserDetail

struct AlwaysFailingUseCase: UseCase {
  let error: NetworkRequestError
  init(error: NetworkRequestError = .serverError) {
    self.error = error
  }
  func callAsFunction(input: String) async throws -> UserDetail {
    throw error
  }
}
