//
//  ForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Matsulenko on 03.10.2023.
//

import UIKit

final class ForecastCollectionViewCell: UICollectionViewCell {
    
    static let id = "ForecastCollectionViewCell"
        
    private lazy var conditionsImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage()
        
        return imageView
    }()
    
    private lazy var rainProbabilitylabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 12)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .black
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .black
        
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
        contentView.addSubview(conditionsImage)
        contentView.addSubview(rainProbabilitylabel)
        contentView.addSubview(timeLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            conditionsImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            conditionsImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            conditionsImage.widthAnchor.constraint(equalToConstant: 16),
            conditionsImage.heightAnchor.constraint(equalTo: conditionsImage.widthAnchor),
            
            rainProbabilitylabel.topAnchor.constraint(equalTo: conditionsImage.bottomAnchor, constant: 4),
            rainProbabilitylabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: rainProbabilitylabel.bottomAnchor, constant: 25),
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setup(with hourData: WeatherForecastHourly) {
        
        if hourData.hours < 10 {
            timeLabel.text = "0" + String(hourData.hours) + ":00"
        } else {
            timeLabel.text = String(hourData.hours) + ":00"
        }
        
        let conditions = hourData.conditions
        let isDark = hourData.isDark
        
        rainProbabilitylabel.text = String(hourData.rainProbability) + "%"
        
        conditionsImage.image = weatherConditionImage(condition: conditions, isDark: isDark, isCurrent: false)
        conditionsImage.tintColor = UIColor(named: "Main")
    }
}
