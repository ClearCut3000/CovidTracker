//
//  ViewController.swift
//  CovidTracker
//
//  Created by Николай Никитин on 26.02.2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

  //MARK: - Properties
  private let tableView: UITableView = {
    let table = UITableView(frame: .zero)
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return table
  }()

  private var scope: APICaller.DataScope = .national

  private var dayData: [DayData] = [] {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }

  private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = .current
    formatter.numberStyle = .scientific
    formatter.groupingSeparator = ","
    return formatter
  }()

  //MARK: - ViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "COVID cases"
    configureTable()
    createFilterButton()
    fetchData()
  }

  //MARK: - Layout Methods
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }

//MARK: - Methods
  private func createText(with data: DayData) -> String? {
    let dateString = DateFormatter.prettyFormatter.string(from: data.date)
    let total = self.numberFormatter.string(from: NSNumber(value: data.count))
    return "\(dateString): \(total ?? "\(data.count)")"
  }

  private func configureTable() {
    view.addSubview(tableView)
    tableView.dataSource = self
  }

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
    APICaller.shared.getCovidData(for: scope) { [weak self] result in
      switch result {
      case .success(let dayData):
        self?.dayData = dayData
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

  //MARK: - TableView Methods
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dayData.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let data = dayData[indexPath.row]
    let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = createText(with: data)
    return cell
  }

}

