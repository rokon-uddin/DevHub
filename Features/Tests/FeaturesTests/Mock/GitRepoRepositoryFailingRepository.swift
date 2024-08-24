//
//  GitRepoRepositoryFailingRepository.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/21/24.
//

@testable import Domain
@testable import NetworkPlatform
@testable import UserDetail

struct GitRepoRepositoryFailingRepository: Domain.GitRepoRepository {
  static var live = Self()
  static var stubbed = Self()
  let error: NetworkRequestError

  init(error: NetworkRequestError = .serverError) {
    self.error = error
  }

  func read(input: RepositoryQuery) async throws -> RepositoryResponse {
    throw error
  }
}
