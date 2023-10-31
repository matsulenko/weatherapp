//
//  OnboardingViewController.swift
//  WeatherApp
//
//  Created by Matsulenko on 26.09.2023.
//

import CoreLocation
import UIKit

final class OnboardingViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    private lazy var onboardingImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "girl")
        
        return imageView
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_SemiBold", size: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(named: "OnboardingVeryLightGray1")
        label.text = "Разрешить приложению Weather использовать данные о местоположении вашего устройства"
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Чтобы получить более точные прогнозы погоды во время движения или путешествия"
        
        return label
    }()
    
    private lazy var additionalInformationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Light_Regular", size: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Вы можете изменить свой выбор в любое время из меню приложения"
        
        return label
    }()
    
    private lazy var deviceLocation = ShadowButton(title: "ИСПОЛЬЗОВАТЬ МЕСТОПОЛОЖЕНИЕ  УСТРОЙСТВА") { [self] in
        locationManager.requestWhenInUseAuthorization()
    }
    
    private lazy var manualLocation: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor(named: "OnboardingVeryLightGray2"), for: .normal)
        button.setTitle("НЕТ, Я БУДУ ДОБАВЛЯТЬ ЛОКАЦИИ", for: .normal)
        button.titleLabel?.font = UIFont(name: "Rubik-Light_Regular", size: 16)
        button.addTarget(self, action: #selector(closeOnboarding), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        addSubviews()
        setupView()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(onboardingImage)
        view.addSubview(mainLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(additionalInformationLabel)
        view.addSubview(deviceLocation)
        view.addSubview(manualLocation)
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "Main")
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            onboardingImage.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            onboardingImage.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -160),
            onboardingImage.widthAnchor.constraint(equalToConstant: 180),
            onboardingImage.heightAnchor.constraint(equalToConstant: 196),
            
            mainLabel.topAnchor.constraint(equalTo: onboardingImage.bottomAnchor, constant: 56),
            mainLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 27),
            mainLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -27),
            
            descriptionLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 56),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 31),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -31),
            
            additionalInformationLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 14),
            additionalInformationLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            additionalInformationLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            
            deviceLocation.topAnchor.constraint(equalTo: additionalInformationLabel.bottomAnchor, constant: 44),
            deviceLocation.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 18),
            deviceLocation.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -18),
            deviceLocation.heightAnchor.constraint(equalToConstant: 40),
            
            manualLocation.topAnchor.constraint(equalTo: deviceLocation.bottomAnchor, constant: 25),
            manualLocation.leadingAnchor.constraint(equalTo: deviceLocation.leadingAnchor),
            manualLocation.trailingAnchor.constraint(equalTo: deviceLocation.trailingAnchor),
            manualLocation.heightAnchor.constraint(equalToConstant: 21),
        ])
    }
    
    @objc
    private func closeOnboarding() {
        self.dismiss(animated: true)
    }
}

extension OnboardingViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            self.closeOnboarding()
        }
    }
}
