//
//  ViewController.swift
//  WeatherApp
//
//  Created by Matsulenko on 25.09.2023.
//
import CoreLocation
import RealmSwift
import UIKit
import WeatherKit

final class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    private let defaults = UserDefaults.standard
    
    var currentLocation: CLLocation?
    
    var isFromDeviceLocation = false
    
    private lazy var dataDaily: [WeatherForecastDaily] = []
    
    private lazy var data24hoursMedium: [WeatherForecastHourly] = []
    
    private lazy var headerView: UIView = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openDetails))
        
        guard let currentLocation = currentLocation else { return UIView() }
        let view = WeatherHeaderView(frame: .zero, currentLocation: currentLocation, locationName: locationName ?? "")
        view.numberOfDaysButton.addTarget(self, action: #selector(changeNumberOfDays), for: .touchUpInside)
        view.details24Hours.addTarget(self, action: #selector(openDetails), for: .touchUpInside)
        view.collectionView.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    lazy var isEmpty: Bool = {
        var bool = false
        if currentLocation == nil {
            bool = true
        }
        
        return bool
    }()
    
    var locationName: String?
    
    private var onboardingWasShown: Bool {
        if defaults.bool(forKey: "OnboardingWasShown") {
            return true
        } else {
            return false
        }
    }
        
    private lazy var whiteView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .right
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 250, weight: .semibold)
        button.setTitle("+", for: .normal)
                
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.sectionFooterHeight = 10
        tableView.sectionHeaderHeight = 0
        tableView.layer.cornerRadius = 5
        tableView.directionalLayoutMargins.leading = 16
        tableView.directionalLayoutMargins.trailing = 16
        tableView.layer.masksToBounds = true
        
        return tableView
    }()
    
    init(isFromDeviceLocation: Bool, currentLocation: CLLocation?) {
        self.isFromDeviceLocation = isFromDeviceLocation
        self.currentLocation = currentLocation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromDeviceLocation {
            Task.detached { [self] in
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()
                }
            }
        }
        
        setupData()
        addSubviews()
        setupView()
        setupConstraints()
        if currentLocation != nil {
            setupTable()
            setup24Hours(location: currentLocation!)
        }
    }
    
    private func setupData() {
        do {
            var dailyWeatherCache: [WeatherForecastDaily] = []
            let realm = try Realm()
            let dailyObjects = realm.objects(WeatherForecastDailyObject.self).sorted(byKeyPath: "index", ascending: true)
            let dailyData: [WeatherForecastDaily] = dailyObjects.map { WeatherForecastDaily(weatherForecastDailyObject: $0) }
            print("daily:",dailyObjects.count)
            for i in dailyData {
                if i.locationName == locationName {
                    dailyWeatherCache.append(i)
                }
            }
            
            if dataDaily.isEmpty {
                dataDaily = dailyWeatherCache
            }
            
            var hourlyWeatherCache: [WeatherForecastHourly] = []
            let hourlyObjects = realm.objects(WeatherForecastHourlyObject.self).sorted(byKeyPath: "index", ascending: true)
            let hourlyData: [WeatherForecastHourly] = hourlyObjects.map { WeatherForecastHourly(weatherForecastHourlyObject: $0) }
            print("hourly:",hourlyObjects.count)
            for i in hourlyData {
                if i.locationName == locationName {
                    hourlyWeatherCache.append(i)
                }
            }
            
            if data24hoursMedium.isEmpty {
                data24hoursMedium = hourlyWeatherCache
            }
            
            if self.isEmpty == false {
                (self.headerView as! WeatherHeaderView).data24hoursMedium = self.data24hoursMedium
                (self.headerView as! WeatherHeaderView).reloadCollectionView()
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        if currentLocation == nil || isFromDeviceLocation == true {
            setTitle(location: location)
            self.refreshData(with: location)
        }
        if isFromDeviceLocation {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let name = "Текущее местоположение"
            locationName = name
            
            let newLocation = Location(latitude: latitude, longitude: longitude, name: name)
            RealmService().saveLocation(newLocation)
        }
    }
    
    private func setTitle(location: CLLocation) {
        
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ru_RU")) { placemarks, error in
            let city = placemarks?.first?.locality
            if city != "" && city != nil {
                self.title = city
                self.navigationController?.navigationBar.topItem?.title = city
            } else {
                self.title = self.locationName
                self.navigationController?.navigationBar.topItem?.title = self.locationName
            }
        }
    }
    
    private func refreshData(with location: CLLocation) {
        isEmpty = false
        currentLocation = location
        setup24Hours(location: location)
        addSubviews()
        setupView()
        setupConstraints()
        if currentLocation != nil {
            setupTable()
        }
        tableView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.view.layoutIfNeeded()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if onboardingWasShown == false {
            showOnboarding()
            defaults.set(true, forKey: "OnboardingWasShown")
        }
        
        if isEmpty {
            title = "Добавить новую локацию"
        } else {
            setTitle(location: currentLocation!)
            Task {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                
                if title == "" || title == nil {
                    title = locationName
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if currentLocation != nil && isEmpty == false {
            refreshData(with: currentLocation!)
        }
        
        if isEmpty == false {
            view.layoutIfNeeded()
            headerView.layoutIfNeeded()
            (headerView as! WeatherHeaderView).mainInfo.loadFromCache()
            (headerView as! WeatherHeaderView).collectionView.reloadData()
            updateNumberOfDays()
            tableView.reloadData()
        }
    }
    
    private func addSubviews() {
        if isEmpty {
            view.addSubview(whiteView)
            view.addSubview(plusButton)
        } else {
            view.addSubview(tableView)
        }
    }

    private func setupView() {
        view.backgroundColor = UIColor(named: "Main")
    }
    
    private func menuButton(action: Selector, imageName: String, width: Double, height: Double) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.tintColor = .black

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: height).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: width).isActive = true
        menuBarItem.tintColor = .black

        return menuBarItem
    }
    
    
    private func showOnboarding() {
        let onboarding = OnboardingViewController()
        onboarding.modalPresentationStyle = .fullScreen
        guard let navigationController = self.navigationController else { return }
        navigationController.present(onboarding, animated: true)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        if isEmpty {
            NSLayoutConstraint.activate([
                whiteView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                whiteView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                whiteView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                whiteView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                
                plusButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
                plusButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
            ])
        }
    }
    
    private func setupTable() {
        tableView.setAndLayoutTableHeaderView(headerView)
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc
    private func changeNumberOfDays() {
        if WeatherOptions.shared.numberOfDays == 7 {
            WeatherOptions.shared.numberOfDays = 10
        } else {
            WeatherOptions.shared.numberOfDays = 7
        }
        
        updateNumberOfDays()
        tableView.reloadData()
    }
    
    @objc
    private func openDetails() {

        let targetViewController = Forecast24HoursViewController(locationName: locationName ?? "", data24hours: data24hoursMedium)
        targetViewController.modalPresentationStyle = .fullScreen
        guard let navigationController = self.navigationController else { return }
        navigationController.present(targetViewController, animated: true)
    }
    
    private func updateNumberOfDays() {
        if isEmpty == false {
            let text = "\(WeatherOptions.shared.numberOfDays) дней"
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
            (headerView as! WeatherHeaderView).numberOfDaysButton.setAttributedTitle(attributedText, for: .normal)
        }
    }
    
    private func setup24Hours(location: CLLocation) {
        
        var isDark = true
        Task.detached {
            guard let hourly = await WeatherData.shared.hourlyForecastWithDates(for: location, startDate: self.view.startTimeDate(), endDate: self.view.endTimeDate()) else { return }
            guard let daily = await WeatherData.shared.dailyForecastWithDates(for: location, startDate: Date(), endDate: self.view.endDate()) else { return }
            
            DispatchQueue.main.async {
                self.dataDaily = []
                for i: Int in 0..<daily.forecast.count {
                    let date = self.view.dateToStringShort(daily.forecast[i].date)
                    let conditions = daily.forecast[i].condition
                    let rainProbability = Int(daily.forecast[i].precipitationChance * 100)
                    let minTemperature = daily.forecast[i].lowTemperature.value
                    let maxTemperature = daily.forecast[i].highTemperature.value
                    
                    let weatherForecastDaily = WeatherForecastDaily(
                        date: date,
                        rainProbability: rainProbability,
                        conditions: conditions,
                        minTemperature: minTemperature,
                        maxTemperature: maxTemperature,
                        locationName: self.locationName,
                        index: i
                    )
                    
                    self.dataDaily.append(weatherForecastDaily)
                    RealmService().saveWeatherForecastDaily(weatherForecastDaily)
                }
                
                self.tableView.reloadData()
                
                let sunriseHours = self.view.getHours(daily.forecast.first!.sun.sunrise!)
                let sunsetHours = self.view.getHours(daily.forecast.first!.sun.sunset!)
                
                self.data24hoursMedium = []
                var i = 0
                var n = 0
                while i < 25 {
                    let date = self.view.dateToStringMedium(hourly.forecast[i].date)
                    let hours = self.view.getHours(hourly.forecast[i].date)
                    let conditions = hourly.forecast[i].condition
                    let temperature = hourly.forecast[i].temperature.value
                    let feelTemperature = hourly.forecast[i].apparentTemperature.value
                    let wind = hourly.forecast[i].wind.speed.converted(to: .metersPerSecond).value
                    let windDirection = hourly.forecast[i].wind.compassDirection
                    let rainProbability = Int(hourly.forecast[i].precipitationChance * 100)
                    let cloudiness = Int(hourly.forecast[i].cloudCover * 100)
                    
                    if sunsetHours > sunriseHours {
                        if self.view.getHours(hourly.forecast[i].date) >= sunriseHours && self.view.getHours(hourly.forecast[i].date) < sunsetHours {
                            isDark = false
                        }
                    } else {
                        if self.view.getHours(hourly.forecast[i].date) >= sunriseHours || self.view.getHours(hourly.forecast[i].date) < sunsetHours {
                            isDark = false
                        }
                    }
                    
                    let forecast = WeatherForecastHourly(
                        date: date,
                        hours: hours,
                        conditions: conditions,
                        temperature: temperature,
                        feelTemperature: feelTemperature,
                        wind: wind,
                        windDirection: windDirection,
                        rainProbability: rainProbability,
                        cloudiness: cloudiness,
                        isDark: isDark,
                        locationName: self.locationName,
                        index: n
                    )
                    
                    self.data24hoursMedium.append(forecast)
                    RealmService().saveWeatherForecastHourly(forecast)
                    i += 3
                    n += 1
                }
                if self.isEmpty == false {
                    (self.headerView as! WeatherHeaderView).data24hoursMedium = self.data24hoursMedium
                    (self.headerView as! WeatherHeaderView).reloadCollectionView()
                }
            }
        }
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataDaily.count < WeatherOptions.shared.numberOfDays {
            dataDaily.count
        } else {
            WeatherOptions.shared.numberOfDays
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.id, for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        let cellData = dataDaily[indexPath.section]
        cell.configure(with: cellData)
        cell.tintColor = .black
        cell.isUserInteractionEnabled = false
        
        return cell
    }
}

extension UITableView {
    func setAndLayoutTableHeaderView(_ header: UIView) {
        self.tableHeaderView = header
        self.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
        header.setNeedsLayout()
        header.layoutIfNeeded()
        header.frame.size =  header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.tableHeaderView = header
    }
}

extension UITableViewCell {
    func addCustomDisclosureIndicator(with color: UIColor) {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .large)
        let symbolImage = UIImage(systemName: "chevron.right",
                                  withConfiguration: symbolConfig)
        button.setImage(symbolImage?.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        button.tintColor = color
        self.accessoryView = button
    }
}
