//
//  DailyViewController.swift
//  CovidTracker
//
//  Created by Николай Никитин on 27.02.2022.
//

import UIKit

class DailyViewController: UIViewController {

  //MARK: - Properties
  var daily: DayData?

  private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = .current
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ","
    return formatter
  }()

  //MARK: - ViewController lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    updateUI()
  }

  private func updateUI() {
    if let date = daily?.date,
       let count = daily?.count,
       let percent = daily?.percent,
       let change = daily?.change,
       let sevenDayChange = daily?.sevenDayChange
    {
      let dateLabel: UILabel = UILabel()
      dateLabel.text = "\(String(describing: DateFormatter.prettyFormatter.string(from: date)))"
      dateLabel.backgroundColor = .red

      let countLabel: UILabel = UILabel()
      countLabel.text = "\(self.numberFormatter.string(from: NSNumber(value: count)) ?? "N/A")"
      countLabel.backgroundColor = .cyan

      let persentLabel: UILabel = UILabel()
      persentLabel.text = "Population persent: \(percent)%"
      persentLabel.backgroundColor = .yellow

      let changeLabel: UILabel = UILabel()
      changeLabel.text = "Changed from prior day: \(change)"
      changeLabel.backgroundColor = .blue

      let sevenDayChangeLabel: UILabel = UILabel()
      sevenDayChangeLabel.text = "Seven day change persent: \(sevenDayChange)%"
      sevenDayChangeLabel.backgroundColor = .green

      var previous: UILabel?

      for label in [dateLabel, countLabel, persentLabel, changeLabel, sevenDayChangeLabel] {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.sizeToFit()
        view.addSubview(label)
        label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: -30).isActive = true
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        if let previous = previous {
          label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
        } else {
          label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        }
        previous = label
      }
    }
  }
}
