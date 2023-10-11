//
//  WeatherForecastCurrent.swift
//  WeatherApp
//
//  Created by Matsulenko on 09.10.2023.
//

import Foundation
import WeatherKit

public struct WeatherForecastCurrent {
    let locationName: String
    let updateTimeString: String
    let temperature: Double
    let currentConditions: String
    let precipitationIntensity: Double
    let weatherSpeed: Double
    let precipitationChance: Double
    let lowTemperature: Double
    let highTemperature: Double
    let sunriseTimeString: String
    let sunsetTimeString: String
    
    var keyedValues: [String: Any] {
        [
            "locationName": locationName,
            "updateTimeString": updateTimeString,
            "temperature": temperature,
            "currentConditions": currentConditions,
            "precipitationIntensity": precipitationIntensity,
            "weatherSpeed": weatherSpeed,
            "precipitationChance": precipitationChance,
            "lowTemperature": lowTemperature,
            "highTemperature": highTemperature,
            "sunriseTimeString": sunriseTimeString,
            "sunsetTimeString": sunsetTimeString
        ]
    }
    
    init(locationName: String, updateTimeString: String, temperature: Double, currentConditions: String, precipitationIntensity: Double, weatherSpeed: Double, precipitationChance: Double, lowTemperature: Double, highTemperature: Double, sunriseTimeString: String, sunsetTimeString: String) {
        self.locationName = locationName
        self.updateTimeString = updateTimeString
        self.temperature = temperature
        self.currentConditions = currentConditions
        self.precipitationIntensity = precipitationIntensity
        self.weatherSpeed = weatherSpeed
        self.precipitationChance = precipitationChance
        self.lowTemperature = lowTemperature
        self.highTemperature = highTemperature
        self.sunriseTimeString = sunriseTimeString
        self.sunsetTimeString = sunsetTimeString
    }
    
    init(weatherForecastCurrentObject: WeatherForecastCurrentObject) {
        self.locationName = weatherForecastCurrentObject.locationName
        self.updateTimeString = weatherForecastCurrentObject.updateTimeString
        self.temperature = weatherForecastCurrentObject.temperature
        self.currentConditions = weatherForecastCurrentObject.currentConditions
        self.precipitationIntensity = weatherForecastCurrentObject.precipitationIntensity
        self.weatherSpeed = weatherForecastCurrentObject.weatherSpeed
        self.precipitationChance = weatherForecastCurrentObject.precipitationChance
        self.lowTemperature = weatherForecastCurrentObject.lowTemperature
        self.highTemperature = weatherForecastCurrentObject.highTemperature
        self.sunriseTimeString = weatherForecastCurrentObject.sunriseTimeString
        self.sunsetTimeString = weatherForecastCurrentObject.sunsetTimeString
    }
}
