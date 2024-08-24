//
//  UserListFailingRepository.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/21/24.
//

@testable import Domain
@testable import Home
@testable import NetworkPlatform

struct UserListFailingRepository: Domain.UsersRepository {
  static var live = Self()
  static var stubbed = Self()
  let error: NetworkRequestError

  init(error: NetworkRequestError = .serverError) {
    self.error = error
  }

  func read(input: Int) async throws -> UsersResponse {
    throw error
  }
}
