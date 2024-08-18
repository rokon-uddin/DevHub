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
  var baseURL: URL {
    return URL(string: BuildConfiguration.shared.baseURLString)!
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
    return ["Authorization": "Bearer \(BuildConfiguration.shared.githubToken)"]
  }

  var parameters: [String: Any]? {
    var params: [String: Any] = [:]
    switch self {
    case .users(let page):
      params["since"] = page
    case .repositories(let param):
      params["q"] = param.query
      //      params["sort"] = param.sort
      //      params["order"] = param.order
      params["page"] = param.page
      params["per_page"] = param.itemPerPage
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
    case .users:
      fileName = "Users"
    case .userDetail:
      fileName = "UserDetail"
    case .repositories:
      fileName = "Repos"
    }
    return stubbedResponse(fileName)
  }

  //  var task: Task {
  //    if let parameters = parameters {
  //      return .requestParameters(
  //        parameters: parameters, encoding: parameterEncoding)
  //    }
  //    return .requestPlain
  //  }

  var task: Task {
    switch self {
    case let .repositories(param):
      let parameters: [String: Any] = [
        "page": param.page,
        "per_page": param.itemPerPage,
        "q": param.query,
      ]
      return .requestParameters(
        parameters: parameters, encoding: URLEncoding.queryString)
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
