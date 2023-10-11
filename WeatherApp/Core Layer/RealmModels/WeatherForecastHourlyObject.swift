//
//  WeatherForecastHourlyObject.swift
//  WeatherApp
//
//  Created by Matsulenko on 09.10.2023.
//

import Foundation
import RealmSwift
import WeatherKit

final class WeatherForecastHourlyObject: Object {
    @Persisted var date: String
    @Persisted var hours: Int
    @Persisted var conditions: WeatherCondition.RawValue
    @Persisted var temperature: Double
    @Persisted var feelTemperature: Double
    @Persisted var wind: Double
    @Persisted var windDirection: Wind.CompassDirection.RawValue
    @Persisted var rainProbability: Int
    @Persisted var cloudiness: Int
    @Persisted var isDark: Bool?
    @Persisted var locationName: String?
    @Persisted var index: Int
    @Persisted var compoundKey: String
    var conditionsEnum: WeatherCondition {
        get {
            return WeatherCondition(rawValue: conditions)!
        }
        set {
            conditions = newValue.rawValue
        }
    }
    var windDirectionEnum: Wind.CompassDirection {
        get {
            return Wind.CompassDirection(rawValue: windDirection)!
        }
        set {
            conditions = newValue.rawValue
        }
    }
    
    override class func primaryKey() -> String? {
        "compoundKey"
    }
    
    convenience init(weatherForecastHourly: WeatherForecastHourly) {
        self.init()
        date = weatherForecastHourly.date
        hours = weatherForecastHourly.hours
        conditions = weatherForecastHourly.conditions.rawValue
        temperature = weatherForecastHourly.temperature
        feelTemperature = weatherForecastHourly.feelTemperature
        wind = weatherForecastHourly.wind
        windDirection = weatherForecastHourly.windDirection.rawValue
        rainProbability = weatherForecastHourly.rainProbability
        cloudiness = weatherForecastHourly.cloudiness
        isDark = weatherForecastHourly.isDark
        locationName = weatherForecastHourly.locationName
        index = weatherForecastHourly.index
        compoundKey = String(weatherForecastHourly.index) + (weatherForecastHourly.locationName ?? "")
    }
}
