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
}
