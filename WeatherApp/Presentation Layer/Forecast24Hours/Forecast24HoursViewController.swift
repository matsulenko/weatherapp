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
    
    private lazy var headerView: Forecast24HoursHeaderView = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
        
        let view = Forecast24HoursHeaderView(frame: .zero, data24hours: data24hours)
        view.data24hours = data24hours
        view.translatesAutoresizingMaskIntoConstraints = false
        view.locationLabel.text = locationName
        view.backImage.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
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
    
    init(locationName: String, data24hours: [WeatherForecastHourly]) {
        self.locationName = locationName
        self.data24hours = data24hours
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
        view.backgroundColor = UIColor(named: "Main")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc
    private func dismissView() {
        self.dismiss(animated: true)
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
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    private func setupTable() {
        tableView.setAndLayoutTableHeaderView(headerView)
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
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
        let cellData = data24hours[indexPath.row + 1]
        cell.configure(with: cellData)
        cell.isUserInteractionEnabled = false
        
        return cell
    }
}
