//
//  ChartValueFormatter.swift
//  WeatherApp
//
//  Created by Matsulenko on 03.10.2023.
//

import DGCharts
import UIKit

final class ChartValueFormatter: NSObject, ValueFormatter {
    fileprivate var numberFormatter: NumberFormatter?

    convenience init(numberFormatter: NumberFormatter) {
        self.init()
        self.numberFormatter = numberFormatter
    }

    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        guard let numberFormatter = numberFormatter
            else {
                return ""
        }
        return numberFormatter.string(for: Int(temperatureFormat(value).rounded()))! + "°"
    }
    
    func temperatureFormat(_ temperature: Double) -> Double {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "TemperatureInF") {
            return celsiusToFahrenheit(temperature)
        } else {
            return temperature
        }
    }
    
    func celsiusToFahrenheit(_ celsius: Double) -> Double {
        return celsius * 1.8 + 32
    }
}
