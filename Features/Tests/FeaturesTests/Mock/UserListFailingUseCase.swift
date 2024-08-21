//
//  UserListFailingUseCase.swift
//
//
//  Created by Mohammed Rokon Uddin on 8/21/24.
//

@testable import Domain
@testable import Home
@testable import NetworkPlatform

struct UserListFailingUseCase: UseCase {
  let error: NetworkRequestError
  init(error: NetworkRequestError = .serverError) {
    self.error = error
  }

  public func callAsFunction(input: Int) async throws -> RemoteResponse<Users> {
    throw error
  }
}
