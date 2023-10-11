//
//  OvalView.swift
//  WeatherApp
//
//  Created by Matsulenko on 28.09.2023.
//

import UIKit

final class OvalView: UIView {
    
    private lazy var ovalLayer: CAShapeLayer = {
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        
        var ovalLayer = CAShapeLayer()
        ovalLayer.path = ovalPath.cgPath
        ovalLayer.fillColor =  UIColor.clear.cgColor
        ovalLayer.strokeColor = UIColor(named: "MainInfoYellow")?.cgColor
        ovalLayer.lineWidth = 3
        ovalLayer.strokeStart = 0.5
        ovalLayer.strokeEnd = 1
        
        return ovalLayer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if layer.sublayers == nil {
            layer.addSublayer(ovalLayer)
        }
            
        ovalLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)).cgPath
        
        backgroundColor = .clear
    }
}
