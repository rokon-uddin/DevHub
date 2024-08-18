//
//  UserDetailClient.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Dependencies
import Domain
import Foundation
import NetworkPlatform

struct UserDetailClient {
  var userDetail: any UserDetailUseCaseType

  init(useCase: UserDetailUseCase) {
    self.userDetail = useCase
  }
}

extension DependencyValues {
  var userDetailClient: UserDetailClient {
    get { self[UserDetailClient.self] }
    set { self[UserDetailClient.self] = newValue }
  }
}

extension UserDetailClient: DependencyKey {
  public static var liveValue = UserDetailClient(
    useCase: UserDetailUseCase(repository: RemoteUserDetailRepository.live))
  public static var testValue = UserDetailClient(
    useCase: UserDetailUseCase(repository: RemoteUserDetailRepository.stubbed))
  public static var previewValue = UserDetailClient(
    useCase: UserDetailUseCase(repository: RemoteUserDetailRepository.stubbed))
}
