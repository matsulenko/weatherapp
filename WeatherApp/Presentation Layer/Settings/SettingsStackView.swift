//
//  SettingsStackView.swift
//  WeatherApp
//
//  Created by Matsulenko on 05.10.2023.
//

import UIKit

final class SettingsStackView: UIStackView {
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        axis = .horizontal
        alignment = .fill
        spacing = 0
        
        layer.cornerRadius = 5
        backgroundColor = .clear
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
