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
