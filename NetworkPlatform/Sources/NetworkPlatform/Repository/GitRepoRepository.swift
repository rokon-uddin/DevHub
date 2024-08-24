//
//  GitRepoRepository.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Domain

public struct GitRepoRepository: Domain.GitRepoRepository {

  private let network: AppNetworking

  private init(network: AppNetworking) {
    self.network = network
  }

  public func read(input: RepositoryQuery) async throws -> RepositoryResponse {
    try await network.requestObject(
      .repositories(input),
      type: RepositoryResponse.self)
  }

  public static var live = GitRepoRepository(
    network: AppNetworking.defaultNetworking())
  public static var stubbed = GitRepoRepository(
    network: AppNetworking.stubbingNetworking())
}
