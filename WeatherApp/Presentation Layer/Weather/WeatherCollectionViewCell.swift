//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Matsulenko on 30.09.2023.
//

import UIKit
import WeatherKit

final class WeatherCollectionViewCell: UICollectionViewCell {
    
    static let id = "WeatherCollectionViewCell"
    
    private var isCurrent = false
    
    var timeZoneIdentifier: String?
    
    private var isDark = true
    
    private var conditions: WeatherCondition?
    
    private lazy var backgroundRectangle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 22
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor(named: "WeatherCollectionView")?.cgColor
        view.layer.borderWidth = 0.5
        
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor(named: "Text")
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private lazy var conditionsImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage()
        
        return imageView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor(named: "Text")
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(backgroundRectangle)
        contentView.addSubview(timeLabel)
        contentView.addSubview(conditionsImage)
        contentView.addSubview(temperatureLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundRectangle.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundRectangle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundRectangle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundRectangle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 40),
            
            conditionsImage.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            conditionsImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            conditionsImage.widthAnchor.constraint(equalToConstant: 16),
            conditionsImage.heightAnchor.constraint(equalTo: conditionsImage.widthAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: conditionsImage.bottomAnchor, constant: 5),
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    func setup(
        with hourData: WeatherForecastHourly
    ) {
        
        var labelText = ""
        
        if hourData.hours < 10 {
            labelText = "0" + String(hourData.hours) + ":00"
        } else {
            labelText = String(hourData.hours) + ":00"
        }
        
        timeLabel.text = timeFormatShort(labelText)
        
        if labelText == self.currentTimeString(timeZoneIdentifier: timeZoneIdentifier) {
            isCurrent = true
        } else {
            isCurrent = false
        }
        
        isDark = hourData.isDark ?? false
        
        conditions = hourData.conditions
        
        conditionsImage.image = weatherConditionImage(condition: conditions!, isDark: isDark, isCurrent: isCurrent)
        
        temperatureLabel.text = doubleToTemperature(temperatureFormat(hourData.temperature))
        
        if isCurrent {
            conditionsImage.tintColor = .white
            timeLabel.textColor = .white
            temperatureLabel.textColor = .white
            backgroundRectangle.backgroundColor = UIColor(named: "Main")
            backgroundRectangle.layer.borderColor = UIColor(named: "Main")?.cgColor
        } else {
            conditionsImage.tintColor = UIColor(named: "MainChart")
            backgroundRectangle.backgroundColor = .clear
            backgroundRectangle.layer.borderColor = UIColor(named: "WeatherCollectionView")?.cgColor
            timeLabel.textColor = UIColor(named: "Text")
            temperatureLabel.textColor = UIColor(named: "Text")
        }
    }
}
