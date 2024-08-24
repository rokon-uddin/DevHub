//
//  UserDetailRepository.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Domain

public struct UserDetailRepository: Domain.UserDetailRepository {

  private let network: AppNetworking

  private init(network: AppNetworking) {
    self.network = network
  }

  public func read(input: String) async throws -> UserDetail {
    try await network.requestObject(
      .userDetail(input),
      type: UserDetail.self)
  }

  public static var live = UserDetailRepository(
    network: AppNetworking.defaultNetworking())
  public static var stubbed = UserDetailRepository(
    network: AppNetworking.stubbingNetworking())
}
