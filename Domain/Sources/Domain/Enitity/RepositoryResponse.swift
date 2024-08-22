//
//  RepositoryResponse.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

public struct RepositoryResponse: Codable, Equatable {
  public let totalCount: Int?
  public let items: [GitHubRepository]?

  public enum CodingKeys: String, CodingKey {
    case totalCount = "total_count"
    case items = "items"
  }

  public init(totalCount: Int?, items: [GitHubRepository]?) {
    self.totalCount = totalCount
    self.items = items
  }
}
