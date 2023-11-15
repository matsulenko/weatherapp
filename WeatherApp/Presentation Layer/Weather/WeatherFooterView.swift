//
//  WeatherFooterView.swift
//  WeatherApp
//
//  Created by Matsulenko on 01.11.2023.
//

import Foundation
import UIKit

final class WeatherFooterView: UIView {
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont(name: "Rubik-Light_Regular", size: 16)
        
        let text = "Delete".localized
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        button.setAttributedTitle(attributedText, for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(deleteButton)
    }
    
    private func setupView() {
        backgroundColor = .clear
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 30),
            deleteButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 10),
        ])
    }
}
