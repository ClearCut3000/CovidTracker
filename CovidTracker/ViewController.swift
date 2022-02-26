//
//  ViewController.swift
//  CovidTracker
//
//  Created by Николай Никитин on 26.02.2022.
//

import UIKit

class ViewController: UIViewController {

  //MARK: - Properties
  private var scope: APICaller.DataScope = .national

  //MARK: - ViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "COVID cases"
    createFilterButton()
  }

//MARK: - Methods
  private func  createFilterButton() {
    let buttonTitle: String = {
      switch scope {
      case .national: return "National"
      case .state(let state): return state.name
      }
    }()
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: buttonTitle, style: .done, target: self, action: #selector(didTapFilter))
  }

  private func fetchData() {
    APICaller.shared.getCovidData(for: scope) { result in
      switch result {
      case .success(let data):
        break
      case .failure(let error):
        print(error)
      }
    }
  }

  @objc private func didTapFilter() {
    let controller = FilterViewController()
    controller.completion = { [weak self] state in
      self?.scope = .state(state)
      self?.fetchData()
      self?.createFilterButton()
    }
    let navigationController = UINavigationController(rootViewController: controller)
    present(navigationController, animated: true)
  }
}

