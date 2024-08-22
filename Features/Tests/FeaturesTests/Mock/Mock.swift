//
//  Mock.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/21/24.
//

import Domain
import Foundation

struct Mock {
  private init() {}
  
  private static func load<T: Decodable>(_ type: T.Type, name: String) -> T {
    guard let url = Bundle.module.url(forResource: name, withExtension: "json") else {
      print("JSON file not found")
      fatalError()
    }

    do {
      let data = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      let item = try decoder.decode(T.self, from: data)

      return item
    } catch {
      print("Error decoding JSON: \(error)")
      fatalError()
    }
  }

  static let users = Self.load([User].self, name: "Users_0")
  static let usersNext = Self.load([User].self, name: "Users_5")
  static let userDetail = Self.load(UserDetail.self, name: "UserDetail")
  static let repositories = Self.load(RepositoryResponse.self, name: "Repos_1")
  static let nextRepositories = Self.load(RepositoryResponse.self, name: "Repos_2")
  static let searchRepositories = Self.load(RepositoryResponse.self, name: "Repos_Search")
}
