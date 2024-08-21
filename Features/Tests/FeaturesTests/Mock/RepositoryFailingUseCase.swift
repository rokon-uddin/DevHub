//
//  RepositoryFailingUseCase.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/21/24.
//

@testable import Domain
@testable import NetworkPlatform
@testable import UserDetail

struct RepositoryFailingUseCase: UseCase {
  let error: NetworkRequestError
  init(error: NetworkRequestError = .serverError) {
    self.error = error
  }

  func callAsFunction(input: RepositoryQuery) async throws -> RepositoryResponse {
    throw error
  }
}
