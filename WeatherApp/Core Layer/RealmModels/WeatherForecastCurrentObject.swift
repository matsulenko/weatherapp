//
//  WeatherForecastCurrentObject.swift
//  WeatherApp
//
//  Created by Matsulenko on 09.10.2023.
//

import Foundation
import RealmSwift

final class WeatherForecastCurrentObject: Object {
    @Persisted var locationName: String
    @Persisted var updateTimeString: String
    @Persisted var temperature: Double
    @Persisted var currentConditions: String
    @Persisted var precipitationIntensity: Double
    @Persisted var weatherSpeed: Double
    @Persisted var precipitationChance: Double
    @Persisted var lowTemperature: Double
    @Persisted var highTemperature: Double
    @Persisted var sunriseTimeString: String
    @Persisted var sunsetTimeString: String
    
    override class func primaryKey() -> String? {
        "locationName"
    }
    
    convenience init(weatherForecastCurrent: WeatherForecastCurrent) {
        self.init()
        locationName = weatherForecastCurrent.locationName
        updateTimeString = weatherForecastCurrent.updateTimeString
        temperature = weatherForecastCurrent.temperature
        currentConditions = weatherForecastCurrent.currentConditions
        precipitationIntensity = weatherForecastCurrent.precipitationIntensity
        weatherSpeed = weatherForecastCurrent.weatherSpeed
        precipitationChance = weatherForecastCurrent.precipitationChance
        lowTemperature = weatherForecastCurrent.lowTemperature
        highTemperature = weatherForecastCurrent.highTemperature
        sunriseTimeString = weatherForecastCurrent.sunriseTimeString
        sunsetTimeString = weatherForecastCurrent.sunsetTimeString
    }
}
