//
//  WeatherForecastHourly.swift
//  WeatherApp
//
//  Created by Matsulenko on 09.10.2023.
//

import Foundation
import WeatherKit

public struct WeatherForecastHourly {
    let date: String
    let hours: Int
    let conditions: WeatherCondition
    let temperature: Double
    let feelTemperature: Double
    let wind: Double
    let windDirection: Wind.CompassDirection
    let rainProbability: Int
    let cloudiness: Int
    let isDark: Bool?
    let locationName: String?
    let index: Int
    
    var keyedValues: [String: Any] {
        [
            "date": date,
            "hours": hours,
            "conditions": conditions.rawValue,
            "temperature": temperature,
            "feelTemperature": feelTemperature,
            "wind": wind,
            "windDirection": windDirection.rawValue,
            "rainProbability": rainProbability,
            "cloudiness": cloudiness,
            "isDark": isDark ?? false,
            "locationName": locationName ?? "",
            "index": index,
            "compoundKey": String(index) + (locationName ?? "")
        ]
    }
    
    init(date: String, hours: Int, conditions: WeatherCondition, temperature: Double, feelTemperature: Double, wind: Double, windDirection: Wind.CompassDirection, rainProbability: Int, cloudiness: Int, isDark: Bool?, locationName: String?, index: Int) {
        self.date = date
        self.hours = hours
        self.conditions = conditions
        self.temperature = temperature
        self.feelTemperature = feelTemperature
        self.wind = wind
        self.windDirection = windDirection
        self.rainProbability = rainProbability
        self.cloudiness = cloudiness
        self.isDark = isDark
        self.locationName = locationName
        self.index = index
    }
    
    init(weatherForecastHourlyObject: WeatherForecastHourlyObject) {
        self.date = weatherForecastHourlyObject.date
        self.hours = weatherForecastHourlyObject.hours
        self.conditions = weatherForecastHourlyObject.conditionsEnum
        self.temperature = weatherForecastHourlyObject.temperature
        self.feelTemperature = weatherForecastHourlyObject.feelTemperature
        self.wind = weatherForecastHourlyObject.wind
        self.windDirection = weatherForecastHourlyObject.windDirectionEnum
        self.rainProbability = weatherForecastHourlyObject.rainProbability
        self.cloudiness = weatherForecastHourlyObject.cloudiness
        self.isDark = weatherForecastHourlyObject.isDark
        self.locationName = weatherForecastHourlyObject.locationName
        self.index = weatherForecastHourlyObject.index
    }
}
