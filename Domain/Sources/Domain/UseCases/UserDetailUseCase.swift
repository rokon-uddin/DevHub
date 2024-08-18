//
//  UserDetailUseCase.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

public typealias UserDetailUseCaseType = UseCase<String, UserDetail>

public final class UserDetailUseCase: UseCase {

  var getUser: (_ input: String) async throws -> UserDetail

  public init<R: RemoteUserDetailRepository>(repository: R)
  where R.ReadInput == Input, R.ReadOutput == Output {
    self.getUser = repository.read(input:)
  }

  public func callAsFunction(input: String) async throws -> UserDetail {
    return try await getUser(input)
  }
}
