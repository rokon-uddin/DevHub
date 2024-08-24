//
//  UsersRepository.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Domain

public struct UsersRepository: Domain.UsersRepository {

  private let network: AppNetworking

  private init(network: AppNetworking) {
    self.network = network
  }

  public func read(input: Int) async throws -> UsersResponse {
    try await network.requestResponseAndHeader(
      .users(input),
      type: Users.self
    ).asUserListResponse
  }

  public static var live = UsersRepository(
    network: AppNetworking.defaultNetworking())
  public static var stubbed = UsersRepository(
    network: AppNetworking.stubbingNetworking())
}
