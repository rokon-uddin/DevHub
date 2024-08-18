//
//  RemoteUserDetailRepository.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Domain

public struct RemoteUserDetailRepository: Domain.RemoteUsersRepository {

  private let network: AppNetworking

  private init(network: AppNetworking) {
    self.network = network
  }

  public func read(input: String) async throws -> UserDetail {
    try await network.requestObject(
      .userDetail(input),
      type: UserDetail.self)
  }

  public static var live = RemoteUserDetailRepository(
    network: AppNetworking.defaultNetworking())
  public static var stubbed = RemoteUserDetailRepository(
    network: AppNetworking.stubbingNetworking())
}
