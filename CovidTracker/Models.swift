//
//  Models.swift
//  CovidTracker
//
//  Created by Николай Никитин on 26.02.2022.
//

import Foundation

struct State: Codable {
  let name: String
  let state_code: String
}

struct StateListResponse: Codable {
  let data: [State]
}

struct CovidDataResponse: Codable {
  let data: [CovidDayData]
}

struct CovidDayData: Codable {
  let cases: CovidCases
  let date: String
}
struct CovidCases: Codable {
  let total: TotalCases
}

struct TotalCases: Codable {
  let value: Int?
}

struct DayData {
  let date: Date
  let count: Int
}
