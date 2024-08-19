//
//  Logger.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation
import os.log

public enum LogLevel {
  case debug
  case info
  case warning
  case error
  case custom(CustomLogLevel)
}

public enum CustomLogLevel {
  case request
  case response
}

// Define an enum for date formatters
public enum LogDateFormatter: String {
  case MM_dd_yyyy_HH_mm_ss_SSS = "MM/dd/yyyy HH:mm:ss:SSS"
  case MM_dd_yyyy_HH_mm_ss = "MM-dd-yyyy HH:mm:ss"
  case E_d_MMM_yyyy_HH_mm_ss_Z = "E, d MMM yyyy HH:mm:ss Z"
  case MMM_d_HH_mm_ss_SSSZ = "MMM d, HH:mm:ss:SSSZ"
}

public protocol LoggerProtocol {
  static func log<T>(
    file: String, function: String, line: Int, logLevel: LogLevel, _ object: T)
}

public class Logger: LoggerProtocol {
  private let logSubsystem = "com.app.logger"
  private init() {}

  public static func log<T>(
    file: String = #file,
    function: String = #function,
    line: Int = #line,
    logLevel: LogLevel,
    _ object: T
  ) {
    switch logLevel {
    case .debug:
      let message = logMessage(
        object, file: file, function: function, line: line)
      os_log("%{public}@", log: .default, type: .debug, message)
    case .info:
      let message = logMessage(
        object, file: file, function: function, line: line)
      os_log("%{public}@", log: .default, type: .info, message)
    case .warning:
      let message = logMessage(
        object, file: file, function: function, line: line)
      os_log("%{public}@", log: .default, type: .default, message)
    case .error:
      let message = logMessage(
        object, file: file, function: function, line: line)
      os_log("%{public}@", log: .default, type: .error, message)
    case .custom(let level):
      switch level {
      case .request:
        let request = object as? URLRequest
        logRequest(request)
      case .response:
        guard
          let (response, data, error) = object
            as? (HTTPURLResponse?, Data?, Error?)
        else {
          os_log(
            "Invalid object passed for response logging.", log: .default,
            type: .error)
          return
        }
        logResponse(response, data: data, error: error)
      }
    }
  }
}

extension Logger {
  private static func logMessage<T>(
    _ object: T, file: String, function: String, line: Int
  ) -> String {
    let fileString = URL(fileURLWithPath: file).lastPathComponent
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = LogDateFormatter.MMM_d_HH_mm_ss_SSSZ.rawValue
    let timestamp = dateFormatter.string(from: Date())
    let objectType = String(describing: type(of: object))
    let memoryAddress = withUnsafePointer(to: object) { "\($0)" }
    let objectValue = String(describing: object)

    let heading = "Log Information"
    let separator =
      "──────────────────────────────────────────────────────────────────"

    // Calculate the length of objectValue
    let lines = objectValue.components(separatedBy: "\n")
    let longestLineLength = lines.map { $0.count }.max() ?? 0

    // Adjust padding for Value section based on longest line length
    let valuePadding = max(50, longestLineLength + 1)

    var logMessage = "\(separator)\n"
    logMessage += "│ \(heading.padding(toLength: separator.count - 2, withPad: " ", startingAt: 0)) │\n"
    logMessage += "\(separator)\n"
    logMessage += "│ Timestamp      │ \(timestamp.padding(toLength: 50, withPad: " ", startingAt: 0)) │\n"
    logMessage += "├─────────────────────────────────────────────────────────────────┤\n"
    logMessage += "│ File           │ \(fileString.padding(toLength: 50, withPad: " ", startingAt: 0)) │\n"
    logMessage += "├─────────────────────────────────────────────────────────────────┤\n"
    logMessage += "│ Function       │ \(function.padding(toLength: 50, withPad: " ", startingAt: 0)) │\n"
    logMessage += "├─────────────────────────────────────────────────────────────────┤\n"
    logMessage += "│ Line           │ \(String(line).padding(toLength: 50, withPad: " ", startingAt: 0)) │\n"
    logMessage += "├─────────────────────────────────────────────────────────────────┤\n"
    logMessage += "│ Object Type    │ \(objectType.padding(toLength: 50, withPad: " ", startingAt: 0)) │\n"
    logMessage += "├─────────────────────────────────────────────────────────────────┤\n"
    logMessage += "│ Memory Address │ \(memoryAddress.padding(toLength: 50, withPad: " ", startingAt: 0)) │\n"
    logMessage += "├─────────────────────────────────────────────────────────────────┤\n"
    logMessage += "│ Value          │ \(objectValue) \(String(repeating: " ", count: valuePadding - longestLineLength)) │\n"
    logMessage += "\(separator)\n"

    return logMessage
  }

  private static func logRequest(_ request: URLRequest?) {
    guard let request = request,
      let url = request.url?.absoluteURL.absoluteString
    else { return }
    os_log("%{public}@", log: .default, type: .info, url)
  }

  private static func logResponse(
    _ response: HTTPURLResponse?, data: Data?, error: Error?
  ) {
    guard let _ = response else { return }
    var logMessage = "Response:"
    if let data = data, let jsonString = String(data: data, encoding: .utf8),
      !jsonString.isEmpty
    {
      logMessage += "\n\(jsonString)"
    }
    if let error = error {
      logMessage += "\nError: \(error.localizedDescription)"
    }

    os_log("%{public}@", log: .default, type: .info, logMessage)
  }
}
