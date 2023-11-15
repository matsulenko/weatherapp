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
    var timeZoneIdentifier: String?
    let defaultTimeZoneIdentifier: String = Calendar.current.timeZone.identifier
    var isFromDeviceLocation = false
    private lazy var dataDaily: [WeatherForecastDaily] = []
    private lazy var data24hoursMedium: [WeatherForecastHourly] = []
    private var sunsetHours: Int?
    private var sunriseHours: Int?
    private var updateTime: Date?
    
    private lazy var headerView: UIView = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openDetails))
        
        guard let currentLocation = currentLocation else { return UIView() }
        let view = WeatherHeaderView(frame: .zero, currentLocation: currentLocation, locationName: locationName ?? "", timeZoneIdentifier: timeZoneIdentifier)
        view.collectionView.addGestureRecognizer(tapGesture)
        
        let tapGestureMain = UITapGestureRecognizer(target: self, action: #selector(self.openDetails))
        view.mainInfo.addGestureRecognizer(tapGestureMain)
        
        return view
    }()
    
    lazy var footerView: WeatherFooterView = {
        let view = WeatherFooterView()
        
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
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .right
        button.setTitleColor(UIColor(named: "Text"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 250, weight: .semibold)
        button.setTitle("+", for: .normal)
                
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "Background")
        tableView.sectionFooterHeight = 10
        tableView.sectionHeaderHeight = 0
        tableView.layer.cornerRadius = 5
        tableView.directionalLayoutMargins.leading = 16
        tableView.directionalLayoutMargins.trailing = 16
        tableView.layer.masksToBounds = true
        
        return tableView
    }()
    
//    private lazy var spinner: UIActivityIndicatorView = {
//        let spinner = UIActivityIndicatorView(style: .large)
//        spinner.color = UIColor(named: "Text")
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//        spinner.hidesWhenStopped = true
//        
//        return spinner
//    }()
    
    init(isFromDeviceLocation: Bool, currentLocation: CLLocation?, timeZoneIdentifier: String?) {
        self.isFromDeviceLocation = isFromDeviceLocation
        self.currentLocation = currentLocation
        self.timeZoneIdentifier = timeZoneIdentifier
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromDeviceLocation {
            if locationName == nil && isEmpty == false {
                locationName = "Current location".localized
            }
            
            Task.detached(priority: .background) { [self] in
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
            
            if timeZoneIdentifier == nil {
                setTimeZoneIdentifier()
            }
            
        }
        setTimer()
    }
    
    private func setTimeZoneIdentifier() {
        Task.detached(priority: .background) { [self] in
            do {
                let placemarks = try await CLGeocoder().reverseGeocodeLocation(currentLocation!)
                
                if !placemarks.isEmpty {
                    if let placemark = placemarks.first {
                        
                        DispatchQueue.main.async {
                            self.timeZoneIdentifier = placemark.timeZone?.identifier
                        }
                        
                    }
                }
            } catch {
                print("Failed to geolocate coordinate: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupData() {
        do {
            var dailyWeatherCache: [WeatherForecastDaily] = []
            let realm = try Realm()
            let dailyObjects = realm.objects(WeatherForecastDailyObject.self).sorted(byKeyPath: "index", ascending: true)
            let dailyData: [WeatherForecastDaily] = dailyObjects.map { WeatherForecastDaily(weatherForecastDailyObject: $0) }
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
            
            if self.sunriseHours == nil && self.sunsetHours == nil {
                let objects = realm.objects(WeatherForecastCurrentObject.self)
                if let object = objects.last(where: { $0.locationName == locationName }) {
                    let currentWeather = WeatherForecastCurrent(weatherForecastCurrentObject: object)
                    if currentWeather.sunriseTimeString != "" {
                        self.sunriseHours = Date().getHoursFromString(currentWeather.sunriseTimeString)
                    }
                    if currentWeather.sunsetTimeString != "" {
                        self.sunsetHours = Date().getHoursFromString(currentWeather.sunsetTimeString)
                    }
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        locationManager.stopUpdatingLocation()
        
        if isFromDeviceLocation {
            
            self.refreshData(with: location)
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let name = "Current location".localized
            
            if locationName == nil {
                locationName = name
            }
            
            if title != "Текущее местоположение" && title != "Current location" {
                setTitle()
            }
            
            let newLocation = Location(latitude: latitude, longitude: longitude, name: name, timeZoneIdentifier: timeZoneIdentifier)
            RealmService().saveLocation(newLocation)
        }
    }
    
    private func setTitle() {
        
        if isEmpty == false {
            title = locationName
            navigationController?.navigationBar.topItem?.title = locationName
        }
    }
    
    private func refreshData(with location: CLLocation) {
        var skipUpdate = false
        
        if updateTime != nil {
            if updateTime!.timeIntervalSinceNow >= -600 && Date().getHours(Date(), timeZoneIdentifier: nil) == Date().getHours(updateTime!, timeZoneIdentifier: nil) {
                skipUpdate = true
            }
        }
        
        if isEmpty == true {
            isEmpty = false
            addSubviews()
            setupView()
            setupConstraints()
        }
        currentLocation = location
        (headerView as! WeatherHeaderView).updateCurrentLocation(location: location)
        
        if skipUpdate == false {
            setup24Hours(location: location)
        }
        if currentLocation != nil {
            setupTable()
        }
        tableView.reloadData()
        (headerView as! WeatherHeaderView).mainInfo.loadFromCache()
        if skipUpdate == false {
            (headerView as! WeatherHeaderView).mainInfo.loadMainData()
        }
        (headerView as! WeatherHeaderView).collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.view.layoutIfNeeded()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if onboardingWasShown == false || locationManager.authorizationStatus == .notDetermined {
            if WeatherOptions.shared.doNotShowOnboarding == false {
                WeatherOptions.shared.doNotShowOnboarding = true
                showOnboarding()
                defaults.set(true, forKey: "OnboardingWasShown")
            }
        }
        
        if isEmpty {
            title = "Add new location".localized
        } else {
            setTitle()
        }
        
        if WeatherOptions.shared.settingsWereUpdated {
            if currentLocation != nil && isEmpty == false {
                refreshData(with: currentLocation!)
            }
        } else {
            tableView.reloadData()
        }
    }
    
    private func addSubviews() {
        if isEmpty {
            view.addSubview(plusButton)
        } else {
            view.addSubview(tableView)
//            view.addSubview(spinner)
        }
    }

    private func setupView() {
        view.backgroundColor = UIColor(named: "Background")
    }
    
    private func menuButton(action: Selector, imageName: String, width: Double, height: Double) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.tintColor = UIColor(named: "Text")

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: height).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: width).isActive = true
        menuBarItem.tintColor = UIColor(named: "Text")

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
                plusButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
                plusButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
//                spinner.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
//                spinner.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
            ])
        }
    }
    
    private func setupTable() {
        tableView.setAndLayoutTableHeaderView(headerView)
        if !isFromDeviceLocation {
            tableView.setAndLayoutFooterView(footerView)
        }
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc
    private func openDetails() {

        let targetViewController = Forecast24HoursViewController(locationName: locationName ?? "", data24hours: data24hoursMedium, timeZoneIdentifier: timeZoneIdentifier, dayNumber: nil)
        guard let navigationController = self.navigationController else { return }
        navigationController.pushViewController(targetViewController, animated: true)
    }
    
    private func setup24Hours(location: CLLocation) {
//        self.spinner.startAnimating()
        Task.detached(priority: .utility) { [self] in
            guard let locationName = await locationName else { return }
            let timeZoneIdentifier: String = await timeZoneIdentifier ?? defaultTimeZoneIdentifier
            
            let dataHourlyTemp = await WeatherLoad().loadHourlyWeather(location: location, locationName: locationName, timeZoneIdentifier: timeZoneIdentifier, sunriseHoursData: sunriseHours, sunsetHoursData: sunsetHours)
            let dataDailyTemp = await WeatherLoad().loadDailyWeather(location: location, locationName: locationName, timeZoneIdentifier: timeZoneIdentifier)
                            
            if dataDailyTemp.count >= 9 {
                Task.detached { @MainActor in
                    self.dataDaily = dataDailyTemp
                }
                for i in dataDailyTemp {
                    RealmService().saveWeatherForecastDaily(i)
                }
            }
                
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            if dataHourlyTemp.count >= 216 {

                for i in dataHourlyTemp {
                    RealmService().saveWeatherForecastHourly(i)
                }
                
                DispatchQueue.main.async { [self] in
                    if isEmpty == false {
                        data24hoursMedium = dataHourlyTemp
                        (self.headerView as! WeatherHeaderView).data24hoursMedium = data24hoursMedium
                        (self.headerView as! WeatherHeaderView).reloadCollectionView()
                        updateTime = Date()
//                        self.spinner.stopAnimating()
                    }
                }
            } else if dataHourlyTemp.count >= 24 {
                DispatchQueue.main.async { [self] in
                    if data24hoursMedium.count == 0 {
                        if isEmpty == false {
                            data24hoursMedium = dataHourlyTemp
                            (self.headerView as! WeatherHeaderView).data24hoursMedium = data24hoursMedium
                            (self.headerView as! WeatherHeaderView).reloadCollectionView()
//                            self.spinner.stopAnimating()
                        }
                    }
                }
            }
        }
    }
    
    private func setTimer() {
        _ = Timer.scheduledTimer(withTimeInterval: 120.0, repeats: true) { [self]
            timer in
            
            if currentLocation != nil && isEmpty == false {
                
                if isFromDeviceLocation {
                    Task.detached(priority: .utility) {
                        self.locationManager.startUpdatingLocation()
                    }
                }
                
                self.refreshData(with: self.currentLocation!)
            }
        }
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dataDaily.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeStatus(recognizer:)))
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.id, for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        cell.timeZoneIdentifier = timeZoneIdentifier
        let cellData = dataDaily[indexPath.section]
        cell.configure(with: cellData)
        cell.tintColor = UIColor(named: "Text")
        cell.isUserInteractionEnabled = true
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    @objc
    func changeStatus(recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let swipeLocation = recognizer.location(in: self.tableView)
            if let swipedIndexPath = tableView.indexPathForRow(at: swipeLocation) {
                if self.tableView.cellForRow(at: swipedIndexPath) != nil {
                    let dayNumber = swipedIndexPath.section
                    
                    if data24hoursMedium.count >= (dayNumber + 1) * 24 {
                    let targetViewController = Forecast24HoursViewController(locationName: locationName ?? "", data24hours: data24hoursMedium, timeZoneIdentifier: timeZoneIdentifier, dayNumber: dayNumber)
                    guard let navigationController = self.navigationController else { return }
                        navigationController.pushViewController(targetViewController, animated: true)
                    }
                }
            }
        }
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
    
    func setAndLayoutFooterView(_ footer: UIView) {
        self.tableFooterView = footer
        self.tableFooterView?.translatesAutoresizingMaskIntoConstraints = true
        NSLayoutConstraint.activate([
            footer.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
        footer.setNeedsLayout()
        footer.layoutIfNeeded()
        footer.frame.size =  footer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.tableFooterView = footer
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
