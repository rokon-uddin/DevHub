//
//  Date+String.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

extension String {
  public var timeAgo: String {
    let dateFormatter = ISO8601DateFormatter()
    guard let date = dateFormatter.date(from: self) else {
      return "0 days ago"
    }

    let calendar = Calendar.current
    let now = Date()

    let years = calendar.dateComponents([.year], from: date, to: now).year ?? 0
    let months =
      calendar.dateComponents([.month], from: date, to: now).month ?? 0
    let weeks =
      calendar.dateComponents([.weekOfMonth], from: date, to: now).weekOfMonth
      ?? 0
    let days = calendar.dateComponents([.day], from: date, to: now).day ?? 0

    if years > 0 {
      return "\(years) years ago"
    } else if months > 0 {
      return "\(months) months ago"
    } else if weeks > 0 {
      return "\(weeks) weeks ago"
    } else {
      return "\(days) days ago"
    }
  }
}
