//
//  UsersUseCase.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

public typealias UsersUseCaseType = UseCase<Int, RemoteResponse<Users>>

public final class UsersUseCase: UseCase {

  var getUsers: (_ input: Int) async throws -> RemoteResponse<Users>

  public init<R: RemoteUsersRepository>(repository: R)
  where R.ReadInput == Input, R.ReadOutput == Output {
    self.getUsers = repository.read(input:)
  }

  public func callAsFunction(input: Int) async throws -> RemoteResponse<Users> {
    return try await getUsers(input)
  }
}
