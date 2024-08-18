//
//  UsersClient.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Dependencies
import Domain
import Foundation
import NetworkPlatform

struct UsersClient {
  var githubUsers: any UsersUseCaseType

  init(usersUseCase: UsersUseCase) {
    self.githubUsers = usersUseCase
  }
}

extension DependencyValues {
  var usersClient: UsersClient {
    get { self[UsersClient.self] }
    set { self[UsersClient.self] = newValue }
  }
}

extension UsersClient: DependencyKey {
  public static var liveValue = UsersClient(
    usersUseCase: UsersUseCase(repository: RemoteUsersRepository.live))
  public static var testValue = UsersClient(
    usersUseCase: UsersUseCase(repository: RemoteUsersRepository.stubbed))
  public static var previewValue = UsersClient(
    usersUseCase: UsersUseCase(repository: RemoteUsersRepository.stubbed))
}
