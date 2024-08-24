//
//  RepositoryUseCase.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

public struct RepositoryUseCase: UseCase {

  var getRepositories: (_ input: RepositoryQuery) async throws -> RepositoryResponse

  public init<R: GitRepoRepository>(repository: R) {
    self.getRepositories = repository.read(input:)
  }

  public func callAsFunction(input: RepositoryQuery) async throws -> RepositoryResponse {
    return try await getRepositories(input)
  }
}
