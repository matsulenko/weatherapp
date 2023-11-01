//
//  WeatherHeaderView.swift
//  WeatherApp
//
//  Created by Matsulenko on 28.09.2023.
//

import CoreLocation
import UIKit
import WeatherKit

final class WeatherHeaderView: UIView {
    
    private var currentLocation: CLLocation
    
    private var timeZoneIdentifier: String?
    
    private var locationName: String
    
    private lazy var numberOfDays = 7
    
    var data24hoursMedium: [WeatherForecastHourly] = []
    
    lazy var mainInfo: WeatherMainInfoView = {
        var view = WeatherMainInfoView(frame: .zero, currentLocation: currentLocation, locationName: locationName, timeZoneIdentifier: timeZoneIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var details24Hours: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .right
        button.setTitleColor(UIColor(named: "Text"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Rubik-Light_Regular", size: 16)
        
        let text = "Подробнее"
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        button.setAttributedTitle(attributedText, for: .normal)
        
        return button
    }()
    
    let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: viewLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(
            WeatherCollectionViewCell.self,
            forCellWithReuseIdentifier: WeatherCollectionViewCell.id
        )
        
        return collectionView
    }()
    
    lazy var numberOfDaysButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .right
        button.setTitleColor(UIColor(named: "Text"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Rubik-Light_Regular", size: 16)
        
        let text = "\(WeatherOptions.shared.numberOfDays) дней"
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        button.setAttributedTitle(attributedText, for: .normal)
        
        return button
    }()
    
    private lazy var tableTitle: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Medium", size: 18)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor(named: "Text")
        label.text = "Ежедневный прогноз"
        
        return label
    }()
    
    init(frame: CGRect, currentLocation: CLLocation, locationName: String, timeZoneIdentifier: String?) {
        self.currentLocation = currentLocation
        self.locationName = locationName
        self.timeZoneIdentifier = timeZoneIdentifier
        super.init(frame: frame)
        
        addSubviews()
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(mainInfo)
        addSubview(details24Hours)
        addSubview(collectionView)
        addSubview(numberOfDaysButton)
        addSubview(tableTitle)
    }
    
    public func updateCurrentLocation(location: CLLocation) {
        currentLocation = location
        mainInfo.currentLocation = location
        mainInfo.timeZoneIdentifier = timeZoneIdentifier
    }
    
    private func setupView() {
        backgroundColor = UIColor(named: "Background")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainInfo.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainInfo.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainInfo.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            mainInfo.heightAnchor.constraint(equalToConstant: 212),
            
            details24Hours.topAnchor.constraint(equalTo: mainInfo.bottomAnchor, constant: 15),
            details24Hours.trailingAnchor.constraint(equalTo: mainInfo.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: details24Hours.bottomAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 85),
            
            numberOfDaysButton.topAnchor.constraint(equalTo: details24Hours.bottomAnchor, constant: 120),
            numberOfDaysButton.trailingAnchor.constraint(equalTo: mainInfo.trailingAnchor),
            
            tableTitle.centerYAnchor.constraint(equalTo: numberOfDaysButton.centerYAnchor),
            tableTitle.leadingAnchor.constraint(equalTo: mainInfo.leadingAnchor),
            
            self.bottomAnchor.constraint(equalTo: numberOfDaysButton.bottomAnchor, constant: 9)
        ])
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}

extension WeatherHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data24hoursMedium.count < (24 + getHours(Date(), timeZoneIdentifier: timeZoneIdentifier)) {
            data24hoursMedium.count
        } else {
            24
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.id, for: indexPath) as! WeatherCollectionViewCell
        cell.timeZoneIdentifier = timeZoneIdentifier
        
        let hourData = data24hoursMedium[indexPath.row + getHours(Date(), timeZoneIdentifier: timeZoneIdentifier)]
        cell.setup(with: hourData)
        
        return cell
    }
    
    
}

extension WeatherHeaderView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 42, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
}
