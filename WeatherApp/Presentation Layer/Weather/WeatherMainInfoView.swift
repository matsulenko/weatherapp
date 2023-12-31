//
//  WeatherMainInfoView.swift
//  WeatherApp
//
//  Created by Matsulenko on 29.09.2023.
//

import CoreLocation
import RealmSwift
import UIKit
import WeatherKit

final class WeatherMainInfoView: UIView {
    
    public var currentLocation: CLLocation
    
    public var timeZoneIdentifier: String?
    
    private var locationName: String
    
    private lazy var mainInfoBackground: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(named: "Main")
        
        return view
    }()
    
    private lazy var ellipse: UIView = {
        var view = OvalView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var nightAndDayTemp: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 16)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    private lazy var currentTemp: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Medium", size: 36)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    private lazy var currentConditions: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 16)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    private lazy var currentPrecipitationLevel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    private lazy var precipitationsImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Precipitations")
        
        return imageView
    }()
    
    private lazy var currentWindLevel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    private lazy var windImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Wind")
        
        return imageView
    }()
    
    private lazy var currentRainProbability: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    private lazy var raindropsImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Raindrops")
        
        return imageView
    }()
    
    private lazy var sunriseTime: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Medium", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    private lazy var sunriseImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Sunrise")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(named: "MainInfoYellow")
        
        return imageView
    }()
    
    private lazy var sunsetTime: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Medium", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    private lazy var sunsetImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Sunset")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(named: "MainInfoYellow")
        
        return imageView
    }()
    
    private lazy var updateTime: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 16)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor(named: "MainInfoYellow")
        label.text = "Loading".localized
        
        return label
    }()
    
        private lazy var spinner: UIActivityIndicatorView = {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.color = .white
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.hidesWhenStopped = true
    
            return spinner
        }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, currentLocation: CLLocation, locationName: String, timeZoneIdentifier: String?) {
        self.currentLocation = currentLocation
        self.locationName = locationName
        self.timeZoneIdentifier = timeZoneIdentifier
        super.init(frame: frame)
        
        addSubviews()
        setupView()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(mainInfoBackground)
        addSubview(ellipse)
        addSubview(nightAndDayTemp)
        addSubview(currentTemp)
        addSubview(currentConditions)
        addSubview(currentWindLevel)
        addSubview(windImage)
        addSubview(currentPrecipitationLevel)
        addSubview(precipitationsImage)
        addSubview(currentRainProbability)
        addSubview(raindropsImage)
        addSubview(sunriseImage)
        addSubview(sunriseTime)
        addSubview(sunsetImage)
        addSubview(sunsetTime)
        addSubview(updateTime)
        addSubview(spinner)
    }
    
    private func setupView() {
        backgroundColor = UIColor(named: "Background")
        
        loadFromCache()
        loadMainData()
    }
    
    public func loadMainData() {
        self.spinner.startAnimating()
        Task.detached(priority: .utility) { [self] in
            if let currentWeather = await WeatherLoad().loadCurrentWeather(currentLocation: currentLocation, locationName: locationName, timeZoneIdentifier: timeZoneIdentifier ?? Calendar.current.timeZone.identifier) {
                DispatchQueue.main.async { [self] in
                    updateLabels(currentWeather: currentWeather)
                }
                RealmService().saveWeatherForecastCurrent(currentWeather)
            }
        }
    }
    
    public func loadFromCache() {
        do {
            let realm = try Realm()
            let objects = realm.objects(WeatherForecastCurrentObject.self)
            guard let object = objects.last(where: { $0.locationName == self.locationName }) else { return }
            let currentWeather = WeatherForecastCurrent(weatherForecastCurrentObject: object)
            updateLabels(currentWeather: currentWeather)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func updateLabels(currentWeather: WeatherForecastCurrent) {
        updateTime.text = Date().timeFormatLong(currentWeather.updateTimeString, timeZoneIdentifier: timeZoneIdentifier)
        currentTemp.text = Date().doubleToTemperature(Date().temperatureFormat(currentWeather.temperature))
        currentConditions.text = currentWeather.currentConditions
        currentPrecipitationLevel.text = Date().doubleToString(currentWeather.precipitationIntensity)
        currentWindLevel.text = "\(Date().doubleToString(Date().windFormat(currentWeather.weatherSpeed))) \(Date().windSuffixMain())"
        currentRainProbability.text = Date().doubleToString(currentWeather.precipitationChance*100) + "%"
        nightAndDayTemp.text = Date().doubleToTemperature(Date().temperatureFormat(currentWeather.lowTemperature)) + "/" + Date().doubleToTemperature(Date().temperatureFormat(currentWeather.highTemperature))
        if currentWeather.sunriseTimeString != "" {
            sunriseTime.text = Date().timeFormat(currentWeather.sunriseTimeString)
        }
        if currentWeather.sunsetTimeString != "" {
            sunsetTime.text = Date().timeFormat(currentWeather.sunsetTimeString)
        }
        self.spinner.stopAnimating()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainInfoBackground.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            mainInfoBackground.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            mainInfoBackground.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainInfoBackground.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            spinner.leadingAnchor.constraint(equalTo: mainInfoBackground.leadingAnchor, constant: 15),
            spinner.topAnchor.constraint(equalTo: mainInfoBackground.topAnchor, constant: 15),
            
            ellipse.leadingAnchor.constraint(equalTo: mainInfoBackground.leadingAnchor, constant: 33),
            ellipse.trailingAnchor.constraint(equalTo: mainInfoBackground.trailingAnchor, constant: -33),
            ellipse.topAnchor.constraint(equalTo: mainInfoBackground.topAnchor, constant: 17),
            ellipse.heightAnchor.constraint(equalToConstant: 246),
            
            nightAndDayTemp.centerXAnchor.constraint(equalTo: mainInfoBackground.centerXAnchor),
            nightAndDayTemp.topAnchor.constraint(equalTo: ellipse.topAnchor, constant: 16),
            
            currentTemp.centerXAnchor.constraint(equalTo: nightAndDayTemp.centerXAnchor),
            currentTemp.topAnchor.constraint(equalTo: nightAndDayTemp.bottomAnchor, constant: 5),
            
            currentConditions.centerXAnchor.constraint(equalTo: currentTemp.centerXAnchor),
            currentConditions.topAnchor.constraint(equalTo: currentTemp.bottomAnchor, constant: 5),
            
            currentWindLevel.centerXAnchor.constraint(equalTo: currentConditions.centerXAnchor, constant: 13),
            currentWindLevel.topAnchor.constraint(equalTo: currentConditions.bottomAnchor, constant: 15),
            
            windImage.centerYAnchor.constraint(equalTo: currentWindLevel.centerYAnchor),
            windImage.trailingAnchor.constraint(equalTo: currentWindLevel.leadingAnchor, constant: -5),
            windImage.widthAnchor.constraint(equalToConstant: 25),
            windImage.heightAnchor.constraint(equalToConstant: 16),
            
            currentPrecipitationLevel.centerYAnchor.constraint(equalTo: currentWindLevel.centerYAnchor),
            currentPrecipitationLevel.leadingAnchor.constraint(equalTo: windImage.leadingAnchor, constant: -28),
            
            precipitationsImage.centerYAnchor.constraint(equalTo: currentPrecipitationLevel.centerYAnchor),
            precipitationsImage.trailingAnchor.constraint(equalTo: currentPrecipitationLevel.leadingAnchor, constant: -5),
            precipitationsImage.widthAnchor.constraint(equalToConstant: 21),
            precipitationsImage.heightAnchor.constraint(equalToConstant: 18),
            
            currentRainProbability.centerYAnchor.constraint(equalTo: currentWindLevel.centerYAnchor),
            currentRainProbability.leadingAnchor.constraint(equalTo: windImage.trailingAnchor, constant: 78),
            
            raindropsImage.centerYAnchor.constraint(equalTo: currentRainProbability.centerYAnchor),
            raindropsImage.trailingAnchor.constraint(equalTo: currentRainProbability.leadingAnchor, constant: -5),
            raindropsImage.widthAnchor.constraint(equalToConstant: 13),
            raindropsImage.heightAnchor.constraint(equalToConstant: 15),
            
            sunriseImage.topAnchor.constraint(equalTo: ellipse.centerYAnchor, constant: 5),
            sunriseImage.leadingAnchor.constraint(equalTo: mainInfoBackground.leadingAnchor, constant: 25),
            sunriseImage.widthAnchor.constraint(equalToConstant: 17),
            sunriseImage.heightAnchor.constraint(equalTo: sunriseImage.widthAnchor),
            
            sunriseTime.topAnchor.constraint(equalTo: sunriseImage.bottomAnchor, constant: 10),
            sunriseTime.centerXAnchor.constraint(equalTo: sunriseImage.centerXAnchor),
            
            sunsetImage.topAnchor.constraint(equalTo: sunriseImage.topAnchor),
            sunsetImage.trailingAnchor.constraint(equalTo: mainInfoBackground.trailingAnchor, constant: -25),
            sunsetImage.widthAnchor.constraint(equalToConstant: 17),
            sunsetImage.heightAnchor.constraint(equalTo: sunriseImage.widthAnchor),
            
            sunsetTime.topAnchor.constraint(equalTo: sunsetImage.bottomAnchor, constant: 10),
            sunsetTime.centerXAnchor.constraint(equalTo: sunsetImage.centerXAnchor),
            
            updateTime.bottomAnchor.constraint(equalTo: mainInfoBackground.bottomAnchor, constant: -21),
            updateTime.centerXAnchor.constraint(equalTo: mainInfoBackground.centerXAnchor),
        ])
    }
}
