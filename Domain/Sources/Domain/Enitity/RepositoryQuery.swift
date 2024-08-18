//
//  RepositoryQuery.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

public struct RepositoryQuery {
  public let page: Int
  public let sort: String
  public let order: String
  public let query: String
  public let itemPerPage: Int

  public init(
    page: Int, sort: String, order: String, query: String, itemPerPage: Int
  ) {
    self.page = page
    self.sort = sort
    self.order = order
    self.query = query
    self.itemPerPage = itemPerPage
  }
}
