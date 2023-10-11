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
        label.textColor = .black
        
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
        label.textColor = .black
        
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
        label.textColor = .black
        label.lineBreakMode = .byTruncatingMiddle
        
        return label
    }()
    
    private lazy var windLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .black
        label.lineBreakMode = .byTruncatingMiddle
        label.text = "Ветер"
        
        return label
    }()
    
    private lazy var precipitationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .black
        label.lineBreakMode = .byTruncatingMiddle
        label.text = "Атмосферные осадки"
        
        return label
    }()
    
    private lazy var cloudinessLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .black
        label.lineBreakMode = .byTruncatingMiddle
        label.text = "Облачность"
        
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
         addSubview(dateLabel)
         addSubview(timeLabel)
         addSubview(temperatureLabel)
         addSubview(conditionsImage)
         addSubview(windImage)
         addSubview(precipitationImage)
         addSubview(cloudinessImage)
         addSubview(conditionsLabel)
         addSubview(windLabel)
         addSubview(precipitationLabel)
         addSubview(cloudinessLabel)
         addSubview(windValueLabel)
         addSubview(precipitationValueLabel)
         addSubview(cloudinessValueLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            
            timeLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            timeLabel.widthAnchor.constraint(equalToConstant: 58),
            
            temperatureLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: 6),
            temperatureLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 59),
            temperatureLabel.widthAnchor.constraint(equalToConstant: 52),
            
            conditionsImage.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: 58),
            conditionsImage.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            conditionsImage.widthAnchor.constraint(equalToConstant: 12),
            conditionsImage.heightAnchor.constraint(equalTo: conditionsImage.widthAnchor),
            
            conditionsLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            conditionsLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 27),
            conditionsLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            windLabel.leadingAnchor.constraint(equalTo: conditionsLabel.leadingAnchor),
            windLabel.topAnchor.constraint(equalTo: conditionsLabel.bottomAnchor, constant: 8),
            windLabel.trailingAnchor.constraint(equalTo: conditionsLabel.trailingAnchor, constant: 100),
            
            windImage.leadingAnchor.constraint(equalTo: conditionsImage.leadingAnchor),
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
        dateLabel.text = weatherForecastMedium.date
        temperatureLabel.text = doubleToTemperature(temperatureFormat(weatherForecastMedium.temperature))
        precipitationValueLabel.text = String(weatherForecastMedium.rainProbability) + "%"
        cloudinessValueLabel.text = String(weatherForecastMedium.cloudiness) + "%"
        
        var timeLabelText: String = ""
        
        if weatherForecastMedium.hours < 10 {
            timeLabelText = "0" + String(weatherForecastMedium.hours) + ":00"
        } else {
            timeLabelText = String(weatherForecastMedium.hours) + ":00"
        }
        
        timeLabel.text = timeFormat(timeLabelText)
        
        let conditions = weatherCondition(weatherForecastMedium.conditions)
        
        conditionsLabel.text = "\(conditions). По ощущению \(doubleToTemperature(temperatureFormat(weatherForecastMedium.feelTemperature)))"
                
        windValueLabel.text = "\(doubleToString(windFormat(weatherForecastMedium.wind))) \(windSuffixTable()) \(windDirectionText(weatherForecastMedium.windDirection))"
        
        conditionsImage.image = weatherConditionImage(condition: weatherForecastMedium.conditions, isDark: weatherForecastMedium.isDark, isCurrent: false)
        conditionsImage.tintColor = UIColor(named: "Main")
    }
}
