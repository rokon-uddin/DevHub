//
//  UserDetailFailingRepository.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/19/24.
//

@testable import Domain
@testable import NetworkPlatform
@testable import UserDetail

struct UserDetailFailingRepository: Domain.UserDetailRepository {
  static var live = Self()
  static var stubbed = Self()
  let error: NetworkRequestError

  init(error: NetworkRequestError = .serverError) {
    self.error = error
  }

  func read(input: String) async throws -> UserDetail {
    throw error
  }
}
