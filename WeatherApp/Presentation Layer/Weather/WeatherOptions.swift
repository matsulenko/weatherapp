//
//  WeatherOptions.swift
//  WeatherApp
//
//  Created by Matsulenko on 01.10.2023.
//

import UIKit

public final class WeatherOptions {
    
    public var numberOfDays: Int = 7
    
    public var doNotShowOnboarding = false
    
    public var settingsWereUpdated = false
    
    static let shared: WeatherOptions = {
        let instance = WeatherOptions()
        
        return instance
    }()
    
    init() {}
}
