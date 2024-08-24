//
//  UserDetailUseCase.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

public struct UserDetailUseCase: UseCase {

  var getUser: (_ input: String) async throws -> UserDetail

  public init<R: UserDetailRepository>(repository: R) {
    self.getUser = repository.read(input:)
  }

  public func callAsFunction(input: String) async throws -> UserDetail {
    return try await getUser(input)
  }
}
