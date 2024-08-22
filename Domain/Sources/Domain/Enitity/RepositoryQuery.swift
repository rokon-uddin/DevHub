//
//  RepositoryQuery.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

public struct RepositoryQuery {
  public let page: Int
  public let login: String
  public let searchText: String
  public let itemPerPage: Int

  public init(page: Int, login: String, searchText: String, itemPerPage: Int = 30) {
    self.page = page
    self.login = login
    self.searchText = searchText
    self.itemPerPage = itemPerPage
  }

  public func build() -> [String: Any] {
    var params: [String: Any] = [:]
    let page = searchText.isEmpty ? page : 1 // Show the first 30 results of users search
    params["q"] = "\(searchText) user:\(login)"
    params["page"] = page
    params["per_page"] = itemPerPage
    return params
  }
}
