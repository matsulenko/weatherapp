//
//  WeatherForecastDailyObject.swift
//  WeatherApp
//
//  Created by Matsulenko on 09.10.2023.
//

import Foundation
import RealmSwift
import WeatherKit

final class WeatherForecastDailyObject: Object {
    @Persisted var date: String
    @Persisted var rainProbability: Int
    @Persisted var conditions: WeatherCondition.RawValue
    @Persisted var minTemperature: Double
    @Persisted var maxTemperature: Double
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
    
    override class func primaryKey() -> String? {
        "compoundKey"
    }
    
    convenience init(weatherForecastDaily: WeatherForecastDaily) {
        self.init()
        date = weatherForecastDaily.date
        rainProbability = weatherForecastDaily.rainProbability
        conditions = weatherForecastDaily.conditions.rawValue
        minTemperature = weatherForecastDaily.minTemperature
        maxTemperature = weatherForecastDaily.maxTemperature
        locationName = weatherForecastDaily.locationName
        index = weatherForecastDaily.index
        compoundKey = String(weatherForecastDaily.index) + (weatherForecastDaily.locationName ?? "")
    }
}
