//
//  RemoteUsersRepository.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Domain

public struct RemoteUsersRepository: Domain.RemoteUsersRepository {

  private let network: AppNetworking

  private init(network: AppNetworking) {
    self.network = network
  }

  public func read(input: Int) async throws -> RemoteResponse<Users> {
    try await network.requestResponse(
      .users(input),
      type: Users.self)
  }

  public static var live = RemoteUsersRepository(
    network: AppNetworking.defaultNetworking())
  public static var stubbed = RemoteUsersRepository(
    network: AppNetworking.stubbingNetworking())
}
