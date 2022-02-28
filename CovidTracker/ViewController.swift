//
//  ViewController.swift
//  CovidTracker
//
//  Created by Николай Никитин on 26.02.2022.
//

import Charts
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
        self.createGraph()
      }
    }
  }

  private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = .current
    formatter.numberStyle = .decimal
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

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    DispatchQueue.main.async {
      self.createGraph()
    }
  }

//MARK: - Methods
  private func createGraph() {
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    var headerHeight = view.frame.size.width / 1.5
    var headerWidht = view.frame.size.width
    if width > height {
      headerWidht = width
      headerHeight = height * 0.7
    }
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: headerWidht, height: headerHeight))
    headerView.clipsToBounds = true
    var entries: [BarChartDataEntry] = []
    let set = dayData.prefix(20)
    for index in 0..<set.count {
      let data = set[index]
      entries.append(.init(x: Double(index), y: Double(data.count)))
    }
    let dataSet = BarChartDataSet(entries: entries)
    dataSet.colors = ChartColorTemplates.joyful()
    let chart = BarChartView(frame: CGRect(x: 0, y: 0, width: headerWidht, height: headerHeight))
    let data: BarChartData = BarChartData(dataSet: dataSet)
    chart.data = data
    chart.rightAxis.enabled = false
    chart.xAxis.labelPosition = .bottom
    chart.legend.enabled = false
    chart.animate(xAxisDuration: 2.5)
    headerView.addSubview(chart)
    tableView.tableHeaderView = headerView
  }

  private func createText(with data: DayData) -> String? {
    let dateString = DateFormatter.prettyFormatter.string(from: data.date)
    let total = self.numberFormatter.string(from: NSNumber(value: data.count))
    return "\(dateString): \(total ?? "\(data.count)")"
  }

  private func configureTable() {
    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.delegate = self
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

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let VC = DailyViewController()
    VC.daily = dayData[indexPath.row]
    self.navigationController?.pushViewController(VC, animated: true)
  }

}

