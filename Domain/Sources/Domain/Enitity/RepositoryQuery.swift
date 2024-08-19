//
//  RepositoryQuery.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

public struct RepositoryQuery {
  public let page: Int
  public let query: String
  public let itemPerPage: Int

  public init(page: Int, query: String, itemPerPage: Int = 30) {
    self.page = page
    self.query = query
    self.itemPerPage = itemPerPage
  }
}
