//
//  VerbosePlugin.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Combine
import Foundation
import Moya
import Utilities

struct VerbosePlugin: PluginType {
  let verbose: Bool

  func prepare(_ request: URLRequest, target _: TargetType) -> URLRequest {
    #if DEBUG
      if let body = request.httpBody {
        if verbose {
          Logger.log(logLevel: .info, body)
        }
      }

      if let headerFields = request.allHTTPHeaderFields {
        if verbose {
          Logger.log(logLevel: .info, headerFields)
        }
      }
    #endif
    return request
  }

  func didReceive(_ result: Result<Response, MoyaError>, target _: TargetType) {
    #if DEBUG
      switch result {
      case let .success(body):
        if verbose {
          if let json = try? JSONSerialization.jsonObject(
            with: body.data, options: .mutableContainers)
          {
            Logger.log(logLevel: .info, json)
          } else {
            let response = String(data: body.data, encoding: .utf8)!
            Logger.log(logLevel: .info, response)
          }
        }
      case .failure(let error):
        Logger.log(logLevel: .error, error.asAppError)
        break
      }
    #endif
  }
}
