//
//  User.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

// MARK: - User
public struct User: Codable, Equatable, Hashable, Identifiable, Sendable {
  public let login: String
  public let id: Int
  public let nodeID: String
  public let avatarURL: String?
  public let gravatarID: String
  public let url: String?
  public let htmlURL: String?
  public let followersURL: String?
  public let followingURL: String?
  public let gistsURL: String?
  public let starredURL: String?
  public let subscriptionsURL: String?
  public let organizationsURL: String?
  public let reposURL: String?
  public let eventsURL: String?
  public let receivedEventsURL: String?
  public let type: TypeEnum
  public let siteAdmin: Bool?

  public enum CodingKeys: String, CodingKey {
    case login = "login"
    case id = "id"
    case nodeID = "node_id"
    case avatarURL = "avatar_url"
    case gravatarID = "gravatar_id"
    case url = "url"
    case htmlURL = "html_url"
    case followersURL = "followers_url"
    case followingURL = "following_url"
    case gistsURL = "gists_url"
    case starredURL = "starred_url"
    case subscriptionsURL = "subscriptions_url"
    case organizationsURL = "organizations_url"
    case reposURL = "repos_url"
    case eventsURL = "events_url"
    case receivedEventsURL = "received_events_url"
    case type = "type"
    case siteAdmin = "site_admin"
  }

  public init(
    login: String, id: Int, nodeID: String, avatarURL: String?,
    gravatarID: String,
    url: String?, htmlURL: String?, followersURL: String?,
    followingURL: String?, gistsURL: String?,
    starredURL: String?, subscriptionsURL: String?, organizationsURL: String?,
    reposURL: String?,
    eventsURL: String?, receivedEventsURL: String?, type: TypeEnum,
    siteAdmin: Bool?
  ) {
    self.login = login
    self.id = id
    self.nodeID = nodeID
    self.avatarURL = avatarURL
    self.gravatarID = gravatarID
    self.url = url
    self.htmlURL = htmlURL
    self.followersURL = followersURL
    self.followingURL = followingURL
    self.gistsURL = gistsURL
    self.starredURL = starredURL
    self.subscriptionsURL = subscriptionsURL
    self.organizationsURL = organizationsURL
    self.reposURL = reposURL
    self.eventsURL = eventsURL
    self.receivedEventsURL = receivedEventsURL
    self.type = type
    self.siteAdmin = siteAdmin
  }
}

public enum TypeEnum: String, Codable, Equatable, Sendable {
  case organization = "Organization"
  case user = "User"
}

public typealias Users = [User]

extension User {
  public static var mock: User {
    User(
      login: "wycats",
      id: 4,
      nodeID: "MDQ6VXNlcjQ=",
      avatarURL: "https://avatars.githubusercontent.com/u/4?v=4",
      gravatarID: "",
      url: "https://api.github.com/users/wycats",
      htmlURL: "https://github.com/wycats",
      followersURL: "https://api.github.com/users/wycats/followers",
      followingURL:
        "https://api.github.com/users/wycats/following{/other_user}",
      gistsURL: "https://api.github.com/users/wycats/gists{/gist_id}",
      starredURL: "https://api.github.com/users/wycats/starred{/owner}{/repo}",
      subscriptionsURL: "https://api.github.com/users/wycats/subscriptions",
      organizationsURL: "https://api.github.com/users/wycats/orgs",
      reposURL: "https://api.github.com/users/wycats/repos",
      eventsURL: "https://api.github.com/users/wycats/events{/privacy}",
      receivedEventsURL: "https://api.github.com/users/wycats/received_events",
      type: .user,
      siteAdmin: false)
  }
}
