//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by Matsulenko on 05.10.2023.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private let defaults = UserDefaults.standard
    
    private lazy var temperatureUnitChosen: TemperatureUnit = {
        var temperatureUnitChosen: TemperatureUnit = .c
        
        if defaults.bool(forKey: "TemperatureInF") {
            temperatureUnitChosen = .f
        }
        
        return temperatureUnitChosen
    }()
    
    private lazy var windSpeedUnitChosen: WindSpeedUnit = {
        var windSpeedUnitChosen: WindSpeedUnit = .km
        
        if defaults.bool(forKey: "WindSpeedInMi") {
            windSpeedUnitChosen = .mi
        }
        
        return windSpeedUnitChosen
    }()
    
    private lazy var timeUnitChosen: TimeUnit = {
        var timeUnitChosen: TimeUnit = .twentyFour
        
        if defaults.bool(forKey: "Time12") {
            timeUnitChosen = .twelve
        }
        
        return timeUnitChosen
    }()
        
    private lazy var whiteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Background")
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .left
        label.numberOfLines = 1
        label.font = UIFont(name: "Rubik-Light_Medium", size: 18)
        label.textColor = UIColor(named: "Text")
        label.text = "Settings".localized
        
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 16)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor(named: "WeatherTableGray")
        label.text = "Temperature".localized
        
        return label
    }()
    
    private lazy var windLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 16)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor(named: "WeatherTableGray")
        label.text = "Wind speed".localized
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 16)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor(named: "WeatherTableGray")
        label.text = "Time format".localized
        
        return label
    }()
    
    private lazy var temperatureButton1: SettingsButton = {
        var isActive = false
        
        if temperatureUnitChosen == .c {
            isActive = true
        }
        
        var button = SettingsButton(title: "C", isActive: isActive) { [self] in
            if temperatureUnitChosen == .f {
                temperatureUnitChosen = .c
                temperatureButton1.backgroundColor = UIColor(named: "Main")
                temperatureButton1.setTitleColor(.white, for: .normal)
                temperatureButton2.backgroundColor = UIColor(named: "SettingsInactive")
                temperatureButton2.setTitleColor(UIColor(named: "Text"), for: .normal)
            }
        }
        
        return button
    }()
    
    private lazy var temperatureButton2: SettingsButton = {
        var isActive = false
        
        if temperatureUnitChosen == .f {
            isActive = true
        }
        
        var button = SettingsButton(title: "F", isActive: isActive) { [self] in
            if temperatureUnitChosen == .c {
                temperatureUnitChosen = .f
                temperatureButton2.backgroundColor = UIColor(named: "Main")
                temperatureButton2.setTitleColor(.white, for: .normal)
                temperatureButton1.backgroundColor = UIColor(named: "SettingsInactive")
                temperatureButton1.setTitleColor(UIColor(named: "Text"), for: .normal)
            }
        }
        
        return button
    }()
    
    private lazy var windButton1: SettingsButton = {
        var isActive = false
        
        if windSpeedUnitChosen == .mi {
            isActive = true
        }
        
        var button = SettingsButton(title: "Mi", isActive: isActive) { [self] in
            if windSpeedUnitChosen == .km {
                windSpeedUnitChosen = .mi
                windButton1.backgroundColor = UIColor(named: "Main")
                windButton1.setTitleColor(.white, for: .normal)
                windButton2.backgroundColor = UIColor(named: "SettingsInactive")
                windButton2.setTitleColor(UIColor(named: "Text"), for: .normal)
            }
        }
        
        return button
    }()
    
    
    private lazy var windButton2: SettingsButton = {
        var isActive = false
        
        if windSpeedUnitChosen == .km {
            isActive = true
        }
        
        var button = SettingsButton(title: "Km", isActive: isActive) { [self] in
            if windSpeedUnitChosen == .mi {
                windSpeedUnitChosen = .km
                windButton2.backgroundColor = UIColor(named: "Main")
                windButton2.setTitleColor(.white, for: .normal)
                windButton1.backgroundColor = UIColor(named: "SettingsInactive")
                windButton1.setTitleColor(UIColor(named: "Text"), for: .normal)
            }
        }
        
        return button
    }()
    
    private lazy var timeButton1: SettingsButton = {
        var isActive = false
        
        if timeUnitChosen == .twelve {
            isActive = true
        }
        
        var button = SettingsButton(title: "12", isActive: isActive) { [self] in
            if timeUnitChosen == .twentyFour {
                timeUnitChosen = .twelve
                timeButton1.backgroundColor = UIColor(named: "Main")
                timeButton1.setTitleColor(.white, for: .normal)
                timeButton2.backgroundColor = UIColor(named: "SettingsInactive")
                timeButton2.setTitleColor(UIColor(named: "Text"), for: .normal)
            }
        }
        
        return button
    }()
    
    private lazy var timeButton2: SettingsButton = {
        var isActive = false
        
        if timeUnitChosen == .twentyFour {
            isActive = true
        }
        
        var button = SettingsButton(title: "24", isActive: isActive) { [self] in
            if timeUnitChosen == .twelve {
                timeUnitChosen = .twentyFour
                timeButton2.backgroundColor = UIColor(named: "Main")
                timeButton2.setTitleColor(.white, for: .normal)
                timeButton1.backgroundColor = UIColor(named: "SettingsInactive")
                timeButton1.setTitleColor(UIColor(named: "Text"), for: .normal)
            }
        }
        
        return button
    }()
    
    private lazy var temperatureButtons: SettingsStackView = {
        let stackView = SettingsStackView()
        stackView.addArrangedSubview(temperatureButton1)
        stackView.addArrangedSubview(temperatureButton2)
        
        return stackView
    }()
    
    private lazy var windButtons: SettingsStackView = {
        let stackView = SettingsStackView()
        stackView.addArrangedSubview(windButton1)
        stackView.addArrangedSubview(windButton2)
        
        return stackView
    }()
    
    private lazy var timeButtons: SettingsStackView = {
        let stackView = SettingsStackView()
        stackView.addArrangedSubview(timeButton1)
        stackView.addArrangedSubview(timeButton2)
        
        return stackView
    }()
    
    private lazy var updateSettings = ShadowButton(title: "Save".localized) { [self] in
        updateDefaults()
        WeatherOptions.shared.settingsWereUpdated = true
        self.dismiss(animated: true)
    }
    
    private lazy var cloud1: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Cloud1")
        imageView.alpha = 0.3
        
        return imageView
    }()
    
    private lazy var cloud2: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Cloud2")
        imageView.alpha = 0.3
        
        return imageView
    }()
    
    private lazy var cloud3: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Cloud3")
        imageView.alpha = 0.3
        
        return imageView
    }()
    
    private lazy var xMark: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "xmark.circle.fill")
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = .systemRed
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        imageView.addGestureRecognizer(tapGesture)
        
        return imageView
    }()
    
    @objc
    private func dismissView() {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupView()
        setupConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(whiteView)
        view.addSubview(titleLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(windLabel)
        view.addSubview(timeLabel)
        view.addSubview(cloud1)
        view.addSubview(cloud2)
        view.addSubview(cloud3)
        view.addSubview(temperatureButtons)
        view.addSubview(windButtons)
        view.addSubview(timeButtons)
        view.addSubview(updateSettings)
        view.addSubview(xMark)
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "Main")
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            whiteView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            whiteView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            whiteView.widthAnchor.constraint(equalToConstant: 320),
            whiteView.heightAnchor.constraint(equalToConstant: 270),
            
            cloud1.heightAnchor.constraint(equalToConstant: 58),
            cloud1.widthAnchor.constraint(equalToConstant: 531),
            cloud1.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 37),
            cloud1.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: -286),
            
            cloud2.heightAnchor.constraint(equalToConstant: 94),
            cloud2.widthAnchor.constraint(equalToConstant: 182),
            cloud2.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 121),
            cloud2.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 10),
            
            cloud3.heightAnchor.constraint(equalToConstant: 65),
            cloud3.widthAnchor.constraint(equalToConstant: 217),
            cloud3.topAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: 81),
            cloud3.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 79),
            
            titleLabel.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 27),
            titleLabel.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 20),
            
            temperatureLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            temperatureLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            temperatureButtons.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor),
            temperatureButtons.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -30),
            temperatureButtons.widthAnchor.constraint(equalToConstant: 80),
            temperatureButtons.heightAnchor.constraint(equalToConstant: 30),
            
            temperatureButton1.widthAnchor.constraint(equalToConstant: 40),
            temperatureButton2.widthAnchor.constraint(equalTo: temperatureButton1.widthAnchor),
            
            windLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 20),
            windLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            windButtons.centerYAnchor.constraint(equalTo: windLabel.centerYAnchor),
            windButtons.trailingAnchor.constraint(equalTo: temperatureButtons.trailingAnchor),
            windButtons.widthAnchor.constraint(equalTo: temperatureButtons.widthAnchor),
            windButtons.heightAnchor.constraint(equalTo: temperatureButtons.heightAnchor),
            
            windButton1.widthAnchor.constraint(equalTo: temperatureButton1.widthAnchor),
            windButton2.widthAnchor.constraint(equalTo: temperatureButton2.widthAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 20),
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            timeButtons.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            timeButtons.trailingAnchor.constraint(equalTo: temperatureButtons.trailingAnchor),
            timeButtons.widthAnchor.constraint(equalTo: temperatureButtons.widthAnchor),
            timeButtons.heightAnchor.constraint(equalTo: temperatureButtons.heightAnchor),
            
            timeButton1.widthAnchor.constraint(equalTo: temperatureButton1.widthAnchor),
            timeButton2.widthAnchor.constraint(equalTo: temperatureButton2.widthAnchor),
            
            updateSettings.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            updateSettings.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -21),
            updateSettings.widthAnchor.constraint(equalToConstant: 250),
            updateSettings.heightAnchor.constraint(equalToConstant: 40),
            
            xMark.widthAnchor.constraint(equalToConstant: 25),
            xMark.heightAnchor.constraint(equalTo: xMark.widthAnchor),
            xMark.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -10),
            xMark.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 10)
        ])
    }
    
    private func updateDefaults() {
        if temperatureUnitChosen == .f {
            defaults.set(true, forKey: "TemperatureInF")
        } else {
            defaults.set(false, forKey: "TemperatureInF")
        }
        
        if windSpeedUnitChosen == .mi {
            defaults.set(true, forKey: "WindSpeedInMi")
        } else {
            defaults.set(false, forKey: "WindSpeedInMi")
        }
        
        if timeUnitChosen == .twelve {
            defaults.set(true, forKey: "Time12")
        } else {
            defaults.set(false, forKey: "Time12")
        }
    }
    
}
