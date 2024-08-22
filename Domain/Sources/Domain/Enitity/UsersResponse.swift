//
//  UsersResponse.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/22/24.
//

import Foundation

public struct UsersResponse {
  public let users: Users
  public let nextPage: Int

  public init(users: Users, nextPage: Int) {
    self.users = users
    self.nextPage = nextPage
  }
}
