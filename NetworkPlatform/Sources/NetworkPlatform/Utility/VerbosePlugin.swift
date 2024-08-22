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
      if verbose {
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
          Logger.log(logLevel: .debug, bodyString)
        }

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
          let headersString = headers.reduce("HTTP_HEADER: ") { partialResult, header in
            partialResult + "\(header.key): \(header.value)"
          }
          Logger.log(logLevel: .debug, headersString)
        }
      }

      Logger.log(logLevel: .custom(.request), request)
    #endif
    return request
  }

  func didReceive(_ result: Result<Response, MoyaError>, target _: TargetType) {
    #if DEBUG
      switch result {
      case let .success(moyaResponse):
        if verbose {
          if let body = moyaResponse.request?.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            Logger.log(logLevel: .debug, bodyString)
          }

          if let headers = moyaResponse.response?.headers, !headers.isEmpty {
            let headersString = headers.reduce("HTTP_HEADER: ") { partialResult, header in
              partialResult + "\(header.name): \(header.value)"
            }
            Logger.log(logLevel: .debug, headersString)
          }
        }
        let response: (HTTPURLResponse?, Data?, Error?) = (moyaResponse.response, moyaResponse.data, nil)
        Logger.log(logLevel: .custom(.response), response)
      case .failure(let error):
        Logger.log(logLevel: .error, error.asAppError)
        break
      }
    #endif
  }
}
