//
//  AppAPI.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import BuildConfiguration
import Domain
import Foundation
import Moya

enum AppAPI {
  case users(Int)
  case userDetail(String)
  case repositories(RepositoryQuery)
}

extension AppAPI: TargetType, ProductAPIType, Stubble {

  var unitTesting: Bool {
    return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
  }

  var baseURL: URL {
    let baseURLString = unitTesting ? "https://api.github.com" : BuildConfiguration.shared.baseURLString
    return URL(string: baseURLString)!
  }

  var path: String {
    switch self {
    case .users: return "/users"
    case .userDetail(let name): return "/users/\(name)"
    case .repositories: return "/search/repositories"
    }
  }

  var method: Moya.Method {
    switch self {
    default:
      return .get
    }
  }

  var headers: [String: String]? {
    if unitTesting || BuildConfiguration.shared.githubToken.isEmpty {
      return [:]
    }

    return ["Authorization": "Bearer " + BuildConfiguration.shared.githubToken]
  }

  var parameters: [String: Any]? {
    var params: [String: Any] = [:]
    switch self {
    case .users(let page):
      params["since"] = page
    case let .repositories(param):
      return param.build()
    default:
      break
    }
    return params
  }

  var parameterEncoding: ParameterEncoding {
    return URLEncoding.default
  }

  var sampleData: Data {
    var fileName = ""
    switch self {
    case let .users(page):
      fileName = "Users_\(page)"
    case .userDetail:
      fileName = "UserDetail"
    case let .repositories(query):
      if query.searchText.isEmpty {
        fileName = "Repos_\(query.page)"
      } else {
        fileName = "Repos_Search"
      }
    }
    return stubbedResponse(fileName)
  }

  var task: Task {
    switch self {
    case let .repositories(param):
      return .requestParameters(
        parameters: param.build(), encoding: URLEncoding.queryString)
    default:
      if let parameters = parameters {
        return .requestParameters(
          parameters: parameters, encoding: parameterEncoding)
      }
      return .requestPlain
    }
  }

  var addXAuth: Bool {
    switch self {
    default: return false
    }
  }
}
