//
//  ForecastTableViewCell.swift
//  WeatherApp
//
//  Created by Matsulenko on 04.10.2023.
//

import UIKit

final class ForecastTableViewCell: UITableViewCell {
    
    static let id = "ForecastTableViewCell"
    
    private lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Medium", size: 18)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor(named: "Text")
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor(named: "WeatherTableGray")
        
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Medium", size: 18)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor(named: "Text")
        
        return label
    }()
    
    private lazy var conditionsImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage()
        
        return imageView
    }()
    
    private lazy var windImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Wind")
        
        return imageView
    }()
    
    private lazy var precipitationImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Raindrops")
        
        return imageView
    }()
    
    private lazy var cloudinessImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Clouds")
        
        return imageView
    }()
    
    private lazy var conditionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor(named: "Text")
        label.lineBreakMode = .byTruncatingMiddle
        
        return label
    }()
    
    private lazy var windLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor(named: "Text")
        label.lineBreakMode = .byTruncatingMiddle
        label.text = "Wind".localized
        
        return label
    }()
    
    private lazy var precipitationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor(named: "Text")
        label.lineBreakMode = .byTruncatingMiddle
        label.text = "Precipitation".localized
        
        return label
    }()
    
    private lazy var cloudinessLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor(named: "Text")
        label.lineBreakMode = .byTruncatingMiddle
        label.text = "Cloudiness".localized
        
        return label
    }()
    
    private lazy var windValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = UIColor(named: "WeatherTableGray")
        label.lineBreakMode = .byTruncatingMiddle
        
        return label
    }()
    
    private lazy var precipitationValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = UIColor(named: "WeatherTableGray")
        label.lineBreakMode = .byTruncatingMiddle
        
        return label
    }()
    
    private lazy var cloudinessValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = UIColor(named: "WeatherTableGray")
        label.lineBreakMode = .byTruncatingMiddle
        
        return label
    }()
    
    private lazy var feeltemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor(named: "Text")
        label.lineBreakMode = .byTruncatingMiddle
        label.text = "Feels like".localized
        
        return label
    }()
    
    private lazy var feeltemperatureImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "thermometer.medium")
        imageView.tintColor = UIColor(named: "MainChart")
        
        return imageView
    }()
    
    private lazy var feeltemperatureValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = UIColor(named: "WeatherTableGray")
        label.lineBreakMode = .byTruncatingMiddle
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(named: "VeryLightBlue")
    }
    
    private func addSubviews() {
        addSubview(timeLabel)
        addSubview(temperatureLabel)
        addSubview(conditionsImage)
        addSubview(windImage)
        addSubview(precipitationImage)
        addSubview(cloudinessImage)
        addSubview(conditionsLabel)
        addSubview(feeltemperatureLabel)
        addSubview(feeltemperatureImage)
        addSubview(feeltemperatureValueLabel)
        addSubview(windLabel)
        addSubview(precipitationLabel)
        addSubview(cloudinessLabel)
        addSubview(windValueLabel)
        addSubview(precipitationValueLabel)
        addSubview(cloudinessValueLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            timeLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 13),
            timeLabel.widthAnchor.constraint(equalToConstant: 58),
            
            temperatureLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: 6),
            temperatureLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 59),
            temperatureLabel.widthAnchor.constraint(equalToConstant: 52),
            
            conditionsImage.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: 58),
            conditionsImage.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            conditionsImage.widthAnchor.constraint(equalToConstant: 12),
            conditionsImage.heightAnchor.constraint(equalTo: conditionsImage.widthAnchor),
            
            conditionsLabel.topAnchor.constraint(equalTo: timeLabel.topAnchor),
            conditionsLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 27),
            conditionsLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            feeltemperatureLabel.leadingAnchor.constraint(equalTo: conditionsLabel.leadingAnchor),
            feeltemperatureLabel.topAnchor.constraint(equalTo: conditionsLabel.bottomAnchor, constant: 8),
            feeltemperatureLabel.trailingAnchor.constraint(equalTo: conditionsLabel.trailingAnchor, constant: 100),
            
            feeltemperatureImage.leadingAnchor.constraint(equalTo: conditionsImage.leadingAnchor),
            feeltemperatureImage.centerYAnchor.constraint(equalTo: feeltemperatureLabel.centerYAnchor),
            feeltemperatureImage.widthAnchor.constraint(equalToConstant: 15),
            feeltemperatureImage.heightAnchor.constraint(equalToConstant: 10),
                        
            feeltemperatureValueLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            feeltemperatureValueLabel.widthAnchor.constraint(equalToConstant: 100),
            feeltemperatureValueLabel.topAnchor.constraint(equalTo: feeltemperatureLabel.topAnchor),
            
            windLabel.leadingAnchor.constraint(equalTo: feeltemperatureLabel.leadingAnchor),
            windLabel.topAnchor.constraint(equalTo: feeltemperatureLabel.bottomAnchor, constant: 8),
            windLabel.trailingAnchor.constraint(equalTo: feeltemperatureLabel.trailingAnchor, constant: 100),
            
            windImage.leadingAnchor.constraint(equalTo: feeltemperatureImage.leadingAnchor),
            windImage.centerYAnchor.constraint(equalTo: windLabel.centerYAnchor),
            windImage.widthAnchor.constraint(equalToConstant: 15),
            windImage.heightAnchor.constraint(equalToConstant: 10),
                        
            windValueLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            windValueLabel.widthAnchor.constraint(equalToConstant: 100),
            windValueLabel.topAnchor.constraint(equalTo: windLabel.topAnchor),
            
            precipitationLabel.leadingAnchor.constraint(equalTo: windLabel.leadingAnchor),
            precipitationLabel.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 8),
            precipitationLabel.trailingAnchor.constraint(equalTo: windLabel.trailingAnchor),
            
            precipitationImage.leadingAnchor.constraint(equalTo: conditionsImage.leadingAnchor),
            precipitationImage.centerYAnchor.constraint(equalTo: precipitationLabel.centerYAnchor),
            precipitationImage.widthAnchor.constraint(equalToConstant: 11),
            precipitationImage.heightAnchor.constraint(equalToConstant: 13),
                        
            precipitationValueLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            precipitationValueLabel.widthAnchor.constraint(equalTo: windValueLabel.widthAnchor),
            precipitationValueLabel.topAnchor.constraint(equalTo: precipitationLabel.topAnchor),
            
            cloudinessLabel.leadingAnchor.constraint(equalTo: precipitationLabel.leadingAnchor),
            cloudinessLabel.topAnchor.constraint(equalTo: precipitationLabel.bottomAnchor, constant: 8),
            cloudinessLabel.trailingAnchor.constraint(equalTo: precipitationLabel.trailingAnchor),
            
            cloudinessImage.leadingAnchor.constraint(equalTo: conditionsImage.leadingAnchor),
            cloudinessImage.centerYAnchor.constraint(equalTo: cloudinessLabel.centerYAnchor),
            cloudinessImage.widthAnchor.constraint(equalToConstant: 14),
            cloudinessImage.heightAnchor.constraint(equalToConstant: 10),
                        
            cloudinessValueLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cloudinessValueLabel.widthAnchor.constraint(equalTo: windValueLabel.widthAnchor),
            cloudinessValueLabel.topAnchor.constraint(equalTo: cloudinessLabel.topAnchor),
            
            contentView.heightAnchor.constraint(equalToConstant: 143)
        ])
    }
    
    func configure(with weatherForecastMedium: WeatherForecastHourly) {
        temperatureLabel.text = Date().doubleToTemperature(Date().temperatureFormat(weatherForecastMedium.temperature))
        precipitationValueLabel.text = String(weatherForecastMedium.rainProbability) + "%"
        cloudinessValueLabel.text = String(weatherForecastMedium.cloudiness) + "%"
        
        var timeLabelText: String = ""
        
        if weatherForecastMedium.hours < 10 {
            timeLabelText = "0" + String(weatherForecastMedium.hours) + ":00"
        } else {
            timeLabelText = String(weatherForecastMedium.hours) + ":00"
        }
        
        timeLabel.text = Date().timeFormatShort(timeLabelText)
        
        let conditions = Date().weatherCondition(weatherForecastMedium.conditions)
        
        conditionsLabel.text = conditions
                
        windValueLabel.text = "\(Date().doubleToString(Date().windFormat(weatherForecastMedium.wind))) \(Date().windSuffixTable()) \(Date().windDirectionText(weatherForecastMedium.windDirection))"
        
        feeltemperatureValueLabel.text = Date().doubleToTemperature(Date().temperatureFormat(weatherForecastMedium.feelTemperature))
        
        conditionsImage.image = Date().weatherConditionImage(condition: weatherForecastMedium.conditions, isDark: weatherForecastMedium.isDark, isCurrent: false)
        conditionsImage.tintColor = UIColor(named: "MainChart")
    }
}
