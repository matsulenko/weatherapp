//
//  WeatherForecast.swift
//  WeatherApp
//
//  Created by Matsulenko on 30.09.2023.
//

import Foundation
import WeatherKit

public struct WeatherForecastDaily {
    let date: String
    let rainProbability: Int
    let conditions: WeatherCondition
    let minTemperature: Double
    let maxTemperature: Double
    let locationName: String?
    let index: Int
    
    var keyedValues: [String: Any] {
        [
            "date": date,
            "rainProbability": rainProbability,
            "conditions": conditions.rawValue,
            "minTemperature": minTemperature,
            "maxTemperature": maxTemperature,
            "locationName": locationName ?? "",
            "index": index,
            "compoundKey": String(index) + (locationName ?? "")
        ]
    }
    
    init(date: String, rainProbability: Int, conditions: WeatherCondition, minTemperature: Double, maxTemperature: Double, locationName: String?, index: Int) {
        self.date = date
        self.rainProbability = rainProbability
        self.conditions = conditions
        self.minTemperature = minTemperature
        self.maxTemperature = maxTemperature
        self.locationName = locationName
        self.index = index
    }
    
    init(weatherForecastDailyObject: WeatherForecastDailyObject) {
        self.date = weatherForecastDailyObject.date
        self.rainProbability = weatherForecastDailyObject.rainProbability
        self.conditions = weatherForecastDailyObject.conditionsEnum
        self.minTemperature = weatherForecastDailyObject.minTemperature
        self.maxTemperature = weatherForecastDailyObject.maxTemperature
        self.locationName = weatherForecastDailyObject.locationName
        self.index = weatherForecastDailyObject.index
    }
}
