//
//  RepositoryUseCase.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

public typealias RepositoryUseCaseType = UseCase<
  RepositoryQuery, RepositoryResponse
>

public final class RepositoryUseCase: UseCase {

  var getRepositories:
    (_ input: RepositoryQuery) async throws -> RepositoryResponse

  public init<R: RemoteUsersRepository>(repository: R)
  where R.ReadInput == Input, R.ReadOutput == Output {
    self.getRepositories = repository.read(input:)
  }

  public func callAsFunction(input: RepositoryQuery) async throws
    -> RepositoryResponse
  {
    return try await getRepositories(input)
  }
}
