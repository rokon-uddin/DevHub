//
//  UsersUseCase.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

public struct UsersUseCase: UseCase {

  var getUsers: (_ input: Int) async throws -> UsersResponse

  public init<R: UsersRepository>(repository: R)
  where R.ReadInput == Input, R.ReadOutput == Output {
    self.getUsers = repository.read(input:)
  }

  public func callAsFunction(input: Int) async throws -> UsersResponse {
    return try await getUsers(input)
  }
}
