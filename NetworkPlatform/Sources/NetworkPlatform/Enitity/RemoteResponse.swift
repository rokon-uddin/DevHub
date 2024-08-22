//
//  RemoteResponse.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Domain
import Foundation

struct RemoteResponse<T: Decodable> {
  var body: T
  var header: [AnyHashable: Any]

  init(data: Data, response: HTTPURLResponse?) throws {
    do {
      let body = try JSONDecoder().decode(T.self, from: data)
      self.init(body: body, response: response)
    } catch {
      throw AppError.parseFailed
    }
  }

  init(body: T, response: HTTPURLResponse?) {
    self.body = body
    header = response?.allHeaderFields ?? [:]
  }
}

extension RemoteResponse {
  var nextPage: String? {
    guard let link = header["Link"] as? String else {
      return nil
    }
    return getUrl(link)
  }

  private func getUrl(_ link: String) -> String? {
    let regexString = "<([^>]+)>;\\s*rel=\"next\""
    let regex = try? NSRegularExpression(pattern: regexString, options: [])
    guard let regex,
      let match = regex.firstMatch(
        in: link, options: [],
        range: NSRange(link.startIndex..<link.endIndex, in: link)),
      let range = Range(match.range(at: 1), in: link)
    else {
      return nil
    }
    return String(link[range])
  }
}

extension RemoteResponse where T == Users {
  var asUserListResponse: UsersResponse {
    var page = 0
    if let nextPage = nextPage,
      let number = Int.parse(from: nextPage)
    {
      page = number
    }
    return UsersResponse(users: self.body, nextPage: page)
  }
}

extension Int {
  static func parse(from string: String) -> Int? {
    Int(
      string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        .joined())
  }
}
