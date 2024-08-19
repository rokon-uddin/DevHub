//
//  UserDetail.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

public struct UserDetail: Codable, Equatable, Identifiable {
  public let login: String
  public let id: Int
  public let nodeID: String?
  public let avatarURL: String?
  public let gravatarID: String?
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
  public let type: String?
  public let siteAdmin: Bool?
  public let name: String?
  public let company: String?
  public let blog: String?
  public let location: String?
  public let email: String?
  public let hireable: String?
  public let bio: String?
  public let twitterUsername: String?
  public let publicRepos: Int?
  public let publicGists: Int?
  public let followers: Int?
  public let following: Int?
  public let createdAt: String?
  public let updatedAt: String?

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
    case name = "name"
    case company = "company"
    case blog = "blog"
    case location = "location"
    case email = "email"
    case hireable = "hireable"
    case bio = "bio"
    case twitterUsername = "twitter_username"
    case publicRepos = "public_repos"
    case publicGists = "public_gists"
    case followers = "followers"
    case following = "following"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
  }

  public init(
    login: String, id: Int, nodeID: String?, avatarURL: String?,
    gravatarID: String?, url: String?, htmlURL: String?, followersURL: String?,
    followingURL: String?, gistsURL: String?, starredURL: String?,
    subscriptionsURL: String?, organizationsURL: String?, reposURL: String?,
    eventsURL: String?, receivedEventsURL: String?, type: String?,
    siteAdmin: Bool?, name: String?, company: String?, blog: String?,
    location: String?, email: String?, hireable: String?, bio: String?,
    twitterUsername: String?, publicRepos: Int?, publicGists: Int?,
    followers: Int?, following: Int?, createdAt: String?, updatedAt: String?
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
    self.name = name
    self.company = company
    self.blog = blog
    self.location = location
    self.email = email
    self.hireable = hireable
    self.bio = bio
    self.twitterUsername = twitterUsername
    self.publicRepos = publicRepos
    self.publicGists = publicGists
    self.followers = followers
    self.following = following
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}

extension UserDetail {
  public static let mock = try! JSONDecoder().decode(UserDetail.self, from: userDetail.data(using: .utf8)!)
}

let userDetail = #"""
  {
      "login": "rokon-uddin",
      "id": 29856113,
      "node_id": "MDQ6VXNlcjI5ODU2MTEz",
      "avatar_url": "https://avatars.githubusercontent.com/u/29856113?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/rokon-uddin",
      "html_url": "https://github.com/rokon-uddin",
      "followers_url": "https://api.github.com/users/rokon-uddin/followers",
      "following_url": "https://api.github.com/users/rokon-uddin/following{/other_user}",
      "gists_url": "https://api.github.com/users/rokon-uddin/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/rokon-uddin/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/rokon-uddin/subscriptions",
      "organizations_url": "https://api.github.com/users/rokon-uddin/orgs",
      "repos_url": "https://api.github.com/users/rokon-uddin/repos",
      "events_url": "https://api.github.com/users/rokon-uddin/events{/privacy}",
      "received_events_url": "https://api.github.com/users/rokon-uddin/received_events",
      "type": "User",
      "site_admin": false,
      "name": "Mohammed Rokon Uddin",
      "company": null,
      "blog": "",
      "location": "Dhaka, Bangladesh",
      "email": null,
      "hireable": null,
      "bio": "Senior Software Engineer | Apple Platform Developer | Cross Platform App Developer using Flutter | Tea Lover ☕️ | Occasional Chef 👨‍🍳| Soccer Player ⚽️ ",
      "twitter_username": "RokonMohammed",
      "public_repos": 63,
      "public_gists": 13,
      "followers": 10,
      "following": 24,
      "created_at": "2017-07-03T07:53:50Z",
      "updated_at": "2024-08-13T12:28:03Z"
  }
  """#
