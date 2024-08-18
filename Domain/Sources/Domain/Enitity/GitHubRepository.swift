//
//  GitHubRepository.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

public struct GitHubRepository: Codable, Equatable, Hashable, Identifiable {
  public var id: Int
  public let name: String
  public let htmlUrl: String?
  public let description: String?
  public let stargazersCount: Int
  public let watchersCount: Int
  public let language: String?
  public let owner: User

  public enum CodingKeys: String, CodingKey {
    case id
    case name
    case owner
    case htmlUrl = "html_url"
    case description
    case stargazersCount = "stargazers_count"
    case watchersCount = "watchers_count"
    case language
  }

  init(
    id: Int,
    name: String,
    htmlUrl: String?,
    description: String?,
    stargazersCount: Int,
    watchersCount: Int,
    language: String?,
    owner: User
  ) {
    self.id = id
    self.name = name
    self.htmlUrl = htmlUrl
    self.description = description
    self.stargazersCount = stargazersCount
    self.watchersCount = watchersCount
    self.language = language
    self.owner = owner
  }
}
