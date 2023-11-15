//
//  WeatherLoad.swift
//  WeatherApp
//
//  Created by Matsulenko on 09.11.2023.
//

import CoreLocation
import Foundation
import RealmSwift
import WeatherKit

final class WeatherLoad {
    
    func loadDailyWeather(location: CLLocation, locationName: String, timeZoneIdentifier: String) async -> [WeatherForecastDaily] {
        
        var dataDaily: [WeatherForecastDaily] = []
        guard let daily = await WeatherData.shared.dailyForecastWithDates(for: location, startDate: Date().startTimeDate(timeZoneIdentifier: timeZoneIdentifier), endDate: Date().endDate(timeZoneIdentifier: timeZoneIdentifier)) else { return [] }
        var n: Int = 0
        
        for i: Int in 0..<daily.forecast.count {
            
            if Date().getDateIndex(daily.forecast[i].date, timeZoneIdentifier: timeZoneIdentifier) < Date().getDateIndex(Date(), timeZoneIdentifier: timeZoneIdentifier) {
                continue
            }
            
            let date = Date().dateToStringFull(daily.forecast[i].date, timeZoneIdentifier: timeZoneIdentifier)
            let conditions = daily.forecast[i].condition
            let rainProbability = Int(daily.forecast[i].precipitationChance * 100)
            let minTemperature = daily.forecast[i].lowTemperature.value
            let maxTemperature = daily.forecast[i].highTemperature.value
            
            let weatherForecastDaily = WeatherForecastDaily(
                date: date,
                rainProbability: rainProbability,
                conditions: conditions,
                minTemperature: minTemperature,
                maxTemperature: maxTemperature,
                locationName: locationName,
                index: n
            )
            
            n += 1
            
            dataDaily.append(weatherForecastDaily)
        }
        
        return dataDaily
    }
    
    func loadHourlyWeather(location: CLLocation, locationName: String, timeZoneIdentifier: String, sunriseHoursData: Int?, sunsetHoursData: Int?) async -> [WeatherForecastHourly] {
        
        var isDark = true
        var sunriseHours: Int? = sunriseHoursData
        var sunsetHours: Int? = sunsetHoursData
        
        if sunriseHours == nil && sunsetHours == nil {
            
            if let daily = await WeatherData.shared.dailyForecastWithDates(for: location, startDate: Date().startTimeDate(timeZoneIdentifier: timeZoneIdentifier), endDate: Date().endDate(timeZoneIdentifier: timeZoneIdentifier)) {
                
                if daily.forecast.first?.sun.sunrise != nil && daily.forecast.first?.sun.sunset != nil {
                    sunriseHours = Date().getHours(daily.forecast.first!.sun.sunrise!, timeZoneIdentifier: timeZoneIdentifier)
                    sunsetHours = Date().getHours(daily.forecast.first!.sun.sunset!, timeZoneIdentifier: timeZoneIdentifier)
                }
            }
        }
        
        guard let hourly = await WeatherData.shared.hourlyForecastWithDates(for: location, startDate: Date().startTimeDate(timeZoneIdentifier: timeZoneIdentifier), endDate: Date().endTimeDate(timeZoneIdentifier: timeZoneIdentifier)) else { return [] }
        
        var dataHourly: [WeatherForecastHourly] = []
        var i = 0
        while i < hourly.forecast.count {
            let date = Date().dateToStringMedium(hourly.forecast[i].date, timeZoneIdentifier: timeZoneIdentifier)
            let hours = Date().getHours(hourly.forecast[i].date, timeZoneIdentifier: timeZoneIdentifier)
            let conditions = hourly.forecast[i].condition
            let temperature = hourly.forecast[i].temperature.value
            let feelTemperature = hourly.forecast[i].apparentTemperature.value
            let wind = hourly.forecast[i].wind.speed.converted(to: .metersPerSecond).value
            let windDirection = hourly.forecast[i].wind.compassDirection
            let rainProbability = Int(hourly.forecast[i].precipitationChance * 100)
            let cloudiness = Int(hourly.forecast[i].cloudCover * 100)
            
            if sunriseHours != nil && sunsetHours != nil {
                if sunsetHours! > sunriseHours! {
                    if Date().getHours(hourly.forecast[i].date, timeZoneIdentifier: timeZoneIdentifier) >= sunriseHours! && Date().getHours(hourly.forecast[i].date, timeZoneIdentifier: timeZoneIdentifier) < sunsetHours! {
                        isDark = false
                    } else {
                        isDark = true
                    }
                } else {
                    if Date().getHours(hourly.forecast[i].date, timeZoneIdentifier: timeZoneIdentifier) >= sunriseHours! {
                        isDark = false
                    } else if Date().getHours(hourly.forecast[i].date, timeZoneIdentifier: timeZoneIdentifier) < sunsetHours! {
                        isDark = false
                    } else {
                        isDark = true
                    }
                }
            } else {
                isDark = false
            }
            
            let forecast = WeatherForecastHourly(
                date: date,
                hours: hours,
                conditions: conditions,
                temperature: temperature,
                feelTemperature: feelTemperature,
                wind: wind,
                windDirection: windDirection,
                rainProbability: rainProbability,
                cloudiness: cloudiness,
                isDark: isDark,
                locationName: locationName,
                index: i
            )
            
            dataHourly.append(forecast)
            i += 1
        }
        
        return dataHourly
    }
    
    
    func loadCurrentWeather(currentLocation: CLLocation, locationName: String, timeZoneIdentifier: String) async -> WeatherForecastCurrent? {
        guard let current = await WeatherData.shared.currentWeather(for: currentLocation) else { return nil }
        guard let hourly = await WeatherData.shared.hourlyForecastWithDates(for: currentLocation, startDate: Date().startTimeDate(timeZoneIdentifier: timeZoneIdentifier), endDate: Date().endTimeDate(timeZoneIdentifier: timeZoneIdentifier)) else { return nil }
        guard let daily = await WeatherData.shared.dailyForecastWithDates(for: currentLocation, startDate: Date().startTimeDate(timeZoneIdentifier: timeZoneIdentifier), endDate: Date().endDate(timeZoneIdentifier: timeZoneIdentifier)) else { return nil }
        
        guard let dailyForecast = daily.forecast.first else { return nil }
        
        var precipitationChance = 0.0
        let currentHour = Date().getHours(Date(), timeZoneIdentifier: timeZoneIdentifier)
        
        if hourly.forecast.count >= currentHour {
            precipitationChance = hourly.forecast[currentHour].precipitationChance
        }
        
        let currentWeather = WeatherForecastCurrent(
            locationName: locationName,
            updateTimeString: Date().dateToStringLong(current.date, timeZoneIdentifier: timeZoneIdentifier),
            temperature: current.temperature.value,
            currentConditions: Date().weatherCondition(current.condition),
            precipitationIntensity: current.precipitationIntensity.value,
            weatherSpeed: current.wind.speed.converted(to: .metersPerSecond).value,
            precipitationChance: precipitationChance,
            lowTemperature: daily.forecast.first!.lowTemperature.value,
            highTemperature: daily.forecast.first!.highTemperature.value,
            sunriseTimeString: Date().dateToStringTime(dailyForecast.sun.sunrise, timeZoneIdentifier: timeZoneIdentifier),
            sunsetTimeString: Date().dateToStringTime(dailyForecast.sun.sunset, timeZoneIdentifier: timeZoneIdentifier)
        )
        
        return currentWeather
    }
}
