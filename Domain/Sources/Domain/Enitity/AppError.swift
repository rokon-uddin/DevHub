//
//  AppError.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

public enum AppError: Error, Identifiable {
  public var id: String { localizedDescription }
  case parseFailed
  case network(_ underlyingError: Error, context: String, file: StaticString = #file, line: Int = #line)
  case unknown
}

extension AppError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .parseFailed:
      return "Parse Error"
    case let .network(underlying, _, _, _):
      return "Description: \(underlying)"
    case .unknown:
      return "Unknown Error"
    }
  }
}

extension AppError: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
    case .parseFailed:
      return "Parse Error"
    case let .network(underlying, context, file, line):
      return "Network Error:\nError Description: \(underlying)\nFile: \(file)\nLine: \(line)\nContext: \(context)"
    case .unknown:
      return "Unknown Error"
    }
  }

}
