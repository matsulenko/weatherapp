//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Matsulenko on 01.10.2023.
//

import UIKit

final class WeatherTableViewCell: UITableViewCell {
    
    static let id = "WeatherCell"
        
    private lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 16)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor(named: "WeatherTableGray")
        
        return label
    }()
    
    private lazy var conditionsLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 16)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = UIColor(named: "Text")
        label.lineBreakMode = .byTruncatingMiddle
        label.focusGroupPriority = .ignored
        
        return label
    }()
    
    private lazy var rainProbabilityLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 12)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor(named: "MainChart")
        
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 18)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = UIColor(named: "Text")
        label.focusGroupPriority = .prioritized
        
        return label
    }()
    
    private lazy var conditionsImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Rain")

        
        return imageView
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
    
    func configure(with weatherForecastShort: WeatherForecastDaily) {
        dateLabel.text = fullToShort(weatherForecastShort.date).lowercased()
        rainProbabilityLabel.text = String(weatherForecastShort.rainProbability) + "%"
        temperatureLabel.text = doubleToTemperature(temperatureFormat(weatherForecastShort.minTemperature)) + "/" + doubleToTemperature(temperatureFormat(weatherForecastShort.maxTemperature))
        
        conditionsLabel.text = weatherCondition(weatherForecastShort.conditions)
        conditionsImage.image = weatherConditionImage(condition: weatherForecastShort.conditions, isDark: false, isCurrent: false)
        conditionsImage.tintColor = UIColor(named: "MainChart")
    }
    
    private func setupView() {
        backgroundColor = UIColor(named: "VeryLightBlue")
    }
    
    private func addSubviews() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(conditionsImage)
        contentView.addSubview(rainProbabilityLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(conditionsLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            dateLabel.widthAnchor.constraint(equalToConstant: 53),
            
            conditionsImage.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            conditionsImage.leftAnchor.constraint(equalTo: dateLabel.leftAnchor),
            conditionsImage.widthAnchor.constraint(equalToConstant: 16),
            conditionsImage.heightAnchor.constraint(equalTo: conditionsImage.widthAnchor),
            conditionsImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            rainProbabilityLabel.leftAnchor.constraint(equalTo: conditionsImage.rightAnchor, constant: 5),
            rainProbabilityLabel.centerYAnchor.constraint(equalTo: conditionsImage.centerYAnchor),
            
            conditionsLabel.rightAnchor.constraint(equalTo: temperatureLabel.leftAnchor),
            conditionsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            conditionsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 66),
            
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            temperatureLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10),
            temperatureLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 110),
            temperatureLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 150),
        ])
    }
}
