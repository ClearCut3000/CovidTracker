//
//  APICaller.swift
//  CovidTracker
//
//  Created by Николай Никитин on 26.02.2022.
//

import Foundation

class APICaller {

  //AMRK: - Properties
  static let shared = APICaller()

  private init () {}

  private struct Constants {
    static let  allStatesUrl = URL(string: "https://api.covidtracking.com/v2/states.json")
  }

  enum DataScope {
    case national
    case state(State)
  }

  //MARK: - Methods
  public func getCovidData(for scope: DataScope, completion: @escaping (Result<String, Error>) -> Void ) {
    let urlString: String
    switch scope {
    case .national:
      urlString = "https://api.covidtracking.com/v2/us/daily.json"
    case .state(let state):
      urlString = "https://api.covidtracking.com/v2/states/\(state.state_code.lowercased())/daily.json"
    }
    guard let url = URL(string: urlString) else { return }
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else { return }
      do {
        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
      }
      catch {
        completion(.failure(error))
      }
    }
    task.resume()
  }

  public func getStateList(completion: @escaping (Result<[State], Error>) -> Void) {
    guard let url = Constants.allStatesUrl else { return }
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else { return }
      do {
        let result = try JSONDecoder().decode(StateListResponse.self, from: data)
        let states = result.data
        completion(.success(states))
      }
      catch {
        completion(.failure(error))
      }
    }
    task.resume()
  }
}
