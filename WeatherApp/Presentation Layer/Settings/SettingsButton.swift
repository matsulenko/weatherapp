//
//  SettingsButton.swift
//  WeatherApp
//
//  Created by Matsulenko on 05.10.2023.
//

import UIKit

final class SettingsButton: UIButton {
    var buttonAction: (() -> Void)?
    
    init(title: String, isActive: Bool, buttonAction: (() -> Void)?) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .center
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont(name: "Rubik-Light_Medium", size: 12)
        
        if isActive {
            backgroundColor = UIColor(named: "Main")
            setTitleColor(.white, for: .normal)
        } else {
            backgroundColor = UIColor(named: "SettingsInactive")
            setTitleColor(.black, for: .normal)
        }
        
        self.buttonAction = buttonAction
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        buttonAction?()
    }
}
