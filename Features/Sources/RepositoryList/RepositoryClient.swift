//
//  RepositoryClient.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Dependencies
import Domain
import Foundation
import NetworkPlatform

struct RepositoryClient {
  var githubRepositories: any RepositoryUseCaseType

  init(useCase: some RepositoryUseCaseType) {
    self.githubRepositories = useCase
  }
}

extension DependencyValues {
  var repositoriesClient: RepositoryClient {
    get { self[RepositoryClient.self] }
    set { self[RepositoryClient.self] = newValue }
  }
}

extension RepositoryClient: DependencyKey {
  public static var liveValue = RepositoryClient(
    useCase: RepositoryUseCase(repository: RemoteGitRepoRepository.live))
  public static var testValue = RepositoryClient(
    useCase: RepositoryUseCase(repository: RemoteGitRepoRepository.stubbed))
  public static var previewValue = RepositoryClient(
    useCase: RepositoryUseCase(repository: RemoteGitRepoRepository.stubbed))
}
