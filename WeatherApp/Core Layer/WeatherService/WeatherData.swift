//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Matsulenko on 07.10.2023.
//

import CoreLocation
import UIKit
import WeatherKit

final class WeatherData {
    
    private let service = WeatherService()
    
    static let shared: WeatherData = {
        let instance = WeatherData()
        
        return instance
    }()
    
    init() {}
    
    func currentWeather(for location: CLLocation) async -> CurrentWeather? {
        let currentWeather = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(for: location, including: .current)
            
            return forcast
        }.value
        
        return currentWeather
    }
    
    func hourlyForecast(for location: CLLocation) async -> Forecast<HourWeather>? {
        let hourWeather = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(for: location, including: .hourly)
            
            return forcast
        }.value
        
        return hourWeather
    }

    func dailyForecast(for location: CLLocation) async -> Forecast<DayWeather>? {
        let dayWeather = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(for: location, including: .daily)
            
            return forcast
        }.value
        
        return dayWeather
    }
    
    func minuteForecast(for location: CLLocation) async -> Forecast<MinuteWeather>? {
        let minuteWeather = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(for: location, including: .minute)
            
            return forcast
        }.value
        
        return minuteWeather
    }
    
    func hourlyForecastWithDates(for location: CLLocation, startDate: Date, endDate: Date) async -> Forecast<HourWeather>? {
        let hourWeather = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(for: location, including: .hourly(startDate: startDate, endDate: endDate))
            
            return forcast
        }.value
        
        return hourWeather
    }
    
    func dailyForecastWithDates(for location: CLLocation, startDate: Date, endDate: Date) async -> Forecast<DayWeather>? {
        let dayWeather = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(for: location, including: .daily(startDate: startDate, endDate: endDate))
            
            return forcast
        }.value
        
        return dayWeather
    }
}
