//
//  DateFormatter+Extension.swift
//  CovidTracker
//
//  Created by Николай Никитин on 26.02.2022.
//

import Foundation
extension DateFormatter {
  static let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd"
    formatter.timeZone = .current
    formatter.locale = .current
    return formatter
  }()

  static let prettyFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeZone = .current
    formatter.locale = .current
    return formatter
  }()
}
