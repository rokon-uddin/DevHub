//
//  NetworkingError.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

enum NetworkingError: Error {
  case error(String)
  case defaultError

  var message: String {
    switch self {
    case let .error(msg):
      return msg
    case .defaultError:
      return "Please try again later."
    }
  }
}
