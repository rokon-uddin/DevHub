//
//  NetworkRequestError.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/19/24.
//

import Foundation

enum NetworkRequestError: LocalizedError, Equatable {
  case invalidURL
  case invalidRequest
  case badRequest
  case unauthorized
  case forbidden
  case notFound
  case error4xx(_ code: Int)
  case serverError
  case error5xx(_ code: Int)
  case decodingError
  case urlSessionFailed(_ error: URLError)
  case unknownError

  var errorDescription: String? {
    switch self {
    case .invalidURL: return "Invalid URL Components"
    case .invalidRequest: return "Invalid request."
    case .badRequest: return "Bad request."
    case .unauthorized: return "Unauthorized access."
    case .forbidden: return "Forbidden access."
    case .notFound: return "Resource not found."
    case .error4xx(let code): return "Client error with status code \(code)."
    case .serverError: return "Internal server error."
    case .error5xx(let code): return "Server error with status code \(code)."
    case .decodingError: return "Failed to decode response."
    case .urlSessionFailed(let error):
      return "Network request failed: \(error.localizedDescription)."
    case .unknownError: return "Unknown error occurred."
    }
  }
}

extension HTTPURLResponse {
  var networkRequestError: NetworkRequestError {
    switch statusCode {
    case 400: return .badRequest
    case 401: return .unauthorized
    case 403: return .forbidden
    case 404: return .notFound
    case 402, 405...499: return .error4xx(statusCode)
    case 500: return .serverError
    case 501...599: return .error5xx(statusCode)
    default: return .unknownError
    }
  }
}
