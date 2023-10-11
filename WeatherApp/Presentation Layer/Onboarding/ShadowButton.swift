//
//  ShadowButton.swift
//  WeatherApp
//
//  Created by Matsulenko on 27.09.2023.
//

import UIKit

final class ShadowButton: UIButton {
    var buttonAction: (() -> Void)?
    
    override var isHighlighted: Bool {
        didSet {
            self.layer.shadowOpacity = self.isHighlighted ? 0.63 : 0
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = self.isSelected ? UIColor(named: "OnboardingButtonSelected") : UIColor(named: "OnboardingButton")
        }
    }
    
    init(title: String, buttonAction: (() -> Void)?) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0
        contentMode = .center
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 10
        backgroundColor = UIColor(named: "OnboardingButton")
        titleLabel?.font = UIFont(name: "Rubik-Light_Medium", size: 12)
        
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
