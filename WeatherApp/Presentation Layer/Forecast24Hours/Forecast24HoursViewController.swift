//
//  Forecast24HoursViewController.swift
//  WeatherApp
//
//  Created by Matsulenko on 01.10.2023.
//

import UIKit

final class Forecast24HoursViewController: UIViewController {
    
    private var data24hours: [WeatherForecastHourly]
    
    private var locationName: String
    
    private var timeZoneIdentifier: String?
    
    private var dayNumber: Int?
    
    private lazy var headerView: Forecast24HoursHeaderView = {
        let view = Forecast24HoursHeaderView(frame: .zero, data24hours: data24hours, timeZoneIdentifier: timeZoneIdentifier, dayNumber: dayNumber)
        view.data24hours = data24hours
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text = locationName
        
        return view
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Background")
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "VeryLightBlue")
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(named: "Main")
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        
        return tableView
    }()
    
    init(locationName: String, data24hours: [WeatherForecastHourly], timeZoneIdentifier: String?, dayNumber: Int?) {
        self.locationName = locationName
        self.data24hours = data24hours
        self.timeZoneIdentifier = timeZoneIdentifier
        self.dayNumber = dayNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupView()
        setupConstraints()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    private func addSubviews() {
        view.addSubview(backgroundView)
        view.addSubview(tableView)
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "Background")
        navigationController?.navigationBar.isHidden = false
        title = setTitle()
        
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: safeArea.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupTable() {
        tableView.setAndLayoutTableHeaderView(headerView)
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setTitle() -> String {
        if dayNumber == nil {
            return "Прогноз на 24 часа"
        } else {
            return Date().fullDateAndDayWithOffset(offset: dayNumber, timeZoneIdentifier: timeZoneIdentifier).lowercased()
        }
    }
}

extension Forecast24HoursViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.id, for: indexPath) as? ForecastTableViewCell else { return UITableViewCell() }
        
        var cellIndex = indexPath.row
        
        if dayNumber == nil {
            cellIndex = 3 * indexPath.row + Date().getHours(Date(), timeZoneIdentifier: timeZoneIdentifier)
        } else {
            var offset: Int = 0
            let zeroHour = data24hours[dayNumber! * 24].hours
            
            if zeroHour == 23 {
                offset = 1
            } else if zeroHour == 1 {
                offset = -1
            }
            
            cellIndex = dayNumber! * 24 + indexPath.row*3 + offset
        }
        
        if cellIndex < data24hours.count {
            let cellData = data24hours[cellIndex]
            cell.configure(with: cellData)
            cell.isUserInteractionEnabled = false
        } else {
            return UITableViewCell()
        }
        
        return cell
    }
}
