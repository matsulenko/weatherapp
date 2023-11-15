//
//  WeatherFormats.swift
//  WeatherApp
//
//  Created by Matsulenko on 07.10.2023.
//

import UIKit
import WeatherKit

extension Date {
    
    func getLocale() -> Locale {
        if Locale.current.language.languageCode?.identifier == "ru" {
            Locale(identifier: "ru_RU")
        } else {
            Locale(identifier: "en")
        }
    }
    
    func temperatureFormat(_ temperature: Double) -> Double {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "TemperatureInF") {
            return celsiusToFahrenheit(temperature)
        } else {
            return temperature
        }
    }
    
    func windFormat(_ wind: Double) -> Double {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "WindSpeedInMi") {
            return msToMph(wind)
        } else {
            return wind
        }
    }
    
    func timeFormat(_ timeString: String) -> String {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "Time12") {
            return timeAmPm(timeString)
        } else {
            return timeString
        }
    }
    
    func timeFormatShort(_ timeString: String) -> String {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "Time12") {
            return timeAmPmShort(timeString)
        } else {
            return timeString
        }
    }
    
    func timeFormatLong(_ timeString: String, timeZoneIdentifier: String?) -> String {
        let defaults = UserDefaults.standard
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier ?? Calendar.current.timeZone.identifier)
        dateFormatter.dateFormat = "HH:mm, E d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let updateTime = dateFormatter.date(from: timeString)!
        
        if updateTime.timeIntervalSinceNow >= -720 {
            return "Updated now".localized
        } else {
            if defaults.bool(forKey: "Time12") {
                let text = timeAmPmLong(timeString, timeZoneIdentifier: Calendar.current.timeZone.identifier)
                if Locale.current.language.languageCode?.identifier == "ru" {
                    return text.lowercased()
                } else {
                    return text
                }
            } else {
                let dateFormatter24 = DateFormatter()
                dateFormatter24.dateFormat = "HH:mm, E d MMMM"
                dateFormatter24.timeZone = TimeZone(identifier: Calendar.current.timeZone.identifier)
                dateFormatter24.locale = getLocale()
                let text = dateFormatter24.string(from: updateTime)
                
                if Locale.current.language.languageCode?.identifier == "ru" {
                    return text.lowercased()
                } else {
                    return text
                }
            }
        }
    }
    
    func windSuffixMain() -> String {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "WindSpeedInMi") {
            return "MPH".localized
        } else {
            return "m/s".localized
        }
    }
    
    func windSuffixTable() -> String {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "WindSpeedInMi") {
            return "MPH".localized
        } else {
            return "m/s".localized
        }
    }
    
    func celsiusToFahrenheit(_ celsius: Double) -> Double {
        return celsius * 1.8 + 32
    }
    
    func msToMph(_ ms: Double) -> Double {
        return ms * 2.23693629
    }
    
    func timeAmPm(_ twentyFourFormat: String) -> String {
        let dateFormatter24 = DateFormatter()
        dateFormatter24.dateFormat = "HH:mm"
        
        let time = dateFormatter24.date(from: twentyFourFormat)!
        
        let dateFormatter12 = DateFormatter()
        dateFormatter12.dateFormat = "h:mm a"
        
        return dateFormatter12.string(from: time)
    }
    
    func timeAmPmShort(_ twentyFourFormat: String) -> String {
        let dateFormatter24 = DateFormatter()
        dateFormatter24.dateFormat = "HH:mm"
        
        let time = dateFormatter24.date(from: twentyFourFormat)!
        
        let dateFormatter12 = DateFormatter()
        dateFormatter12.dateFormat = "h a"
        
        return dateFormatter12.string(from: time)
    }
    
    func timeAmPmLong(_ twentyFourFormat: String, timeZoneIdentifier: String?) -> String {
        let dateFormatter24 = DateFormatter()
        dateFormatter24.dateFormat = "HH:mm, E d MMMM yyyy"
        dateFormatter24.timeZone = TimeZone(identifier: timeZoneIdentifier ?? Calendar.current.timeZone.identifier)
        dateFormatter24.locale = Locale(identifier: "ru_RU")
        
        let time = dateFormatter24.date(from: twentyFourFormat)!
        
        let dateFormatter12 = DateFormatter()
        dateFormatter12.dateFormat = "h:mm a, E d MMMM"
        dateFormatter12.timeZone = TimeZone(identifier: timeZoneIdentifier ?? Calendar.current.timeZone.identifier)
        dateFormatter12.locale = getLocale()
        
        return dateFormatter12.string(from: time)
    }
    
    func doubleToString(_ double: Double?) -> String {
        guard let double = double else { return "" }
        return String(Int(double.rounded()))
    }
    
    func doubleToTemperature(_ double: Double?) -> String {
        guard let double = double else { return "" }
        return String(Int(double.rounded())) + "°"
    }
    
    func dateToStringLong(_ date: Date?, timeZoneIdentifier: String?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, E d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier ?? Calendar.current.timeZone.identifier)
        
        return dateFormatter.string(from: date)
    }
    
    func stringToDateLong(_ dateString: String, timeZoneIdentifier: String?) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, E d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier ?? Calendar.current.timeZone.identifier)
        
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
    func dateToStringShort(_ date: Date?, timeZoneIdentifier: String?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E d"
        dateFormatter.locale = getLocale()
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier ?? Calendar.current.timeZone.identifier)
        
        return dateFormatter.string(from: date)
    }
    
    func dateToStringMedium(_ date: Date?, timeZoneIdentifier: String?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E dd/MM"
        dateFormatter.locale = getLocale()
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier ?? Calendar.current.timeZone.identifier)
        let text = dateFormatter.string(from: date).lowercased()
        
        if Locale.current.language.languageCode?.identifier == "ru" {
            return text.lowercased()
        } else {
            return text
        }
    }
    
    func fullToShort(_ dateString: String?, timeZoneIdentifier: String?) -> String {
        guard let date = stringToDateFull(dateString) else { return "" }
        
        return dateToStringShort(date, timeZoneIdentifier: timeZoneIdentifier)
    }
    
    func dateToStringFull(_ date: Date?, timeZoneIdentifier: String?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier ?? Calendar.current.timeZone.identifier)
        
        return dateFormatter.string(from: date)
    }
    
    func dateToStringTime(_ date: Date?, timeZoneIdentifier: String?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier ?? Calendar.current.timeZone.identifier)
        
        return dateFormatter.string(from: date)
    }
    
    func stringToDateFull(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        return dateFormatter.date(from: dateString)
    }
    
    func getHours(_ date: Date, timeZoneIdentifier: String?) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H"
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier ?? Calendar.current.timeZone.identifier)
        
        return Int(dateFormatter.string(from: date))!
    }
    
    func getHoursFromString(_ timeString: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let date = dateFormatter.date(from: timeString)!
        
        let hoursDateFormatter = DateFormatter()
        hoursDateFormatter.dateFormat = "H"
        
        return Int(hoursDateFormatter.string(from: date))!
    }
    
    func getDateIndex(_ date: Date, timeZoneIdentifier: String?) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier ?? Calendar.current.timeZone.identifier)
        
        return Int(dateFormatter.string(from: date))!
    }
    
    func calculateTimeInterval(_ date: Date, from: TimeZone, to: TimeZone) -> TimeInterval {
        let sourceOffset = from.secondsFromGMT(for: date)
        let destinationOffset = to.secondsFromGMT(for: date)
        return TimeInterval(destinationOffset - sourceOffset)
    }
    
    func changeToTimeZone(_ date: Date, from: TimeZone, to: TimeZone) -> Date {
        let timeInterval = calculateTimeInterval(date, from: from, to: to)
        return Date(timeInterval: timeInterval, since: date)
    }
    
    func startTimeDate(timeZoneIdentifier: String?) -> Date {
        
        let dateString = dateToStringWithoutTime(Date(), timeZoneIdentifier: timeZoneIdentifier)
        let newDate = stringToDateWithoutTime(dateString, timeZoneIdentifier: timeZoneIdentifier)
        
        return newDate
    }
    
    func dateToStringWithoutTime(_ date: Date?, timeZoneIdentifier: String?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier ?? Calendar.current.timeZone.identifier)
        
        return dateFormatter.string(from: date)
    }
    
    func stringToDateWithoutTime(_ dateString: String, timeZoneIdentifier: String?) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier ?? Calendar.current.timeZone.identifier)
        
        return dateFormatter.date(from: dateString)!
    }
    
    func startTimeString(timeZoneIdentifier: String?) -> String {
        let startTime = startTimeDate(timeZoneIdentifier: timeZoneIdentifier)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: startTime)
    }
    
    func endTimeDate(timeZoneIdentifier: String?) -> Date {
        let startTime = startTimeDate(timeZoneIdentifier: timeZoneIdentifier)
        
        return Calendar.current.date(byAdding: .hour, value: 240, to: startTime)!
    }
    
    func addHoursToStartTime(_ hours: Int, timeZoneIdentifier: String?) -> Date {
        let startTime = startTimeDate(timeZoneIdentifier: timeZoneIdentifier)
        
        return Calendar.current.date(byAdding: .hour, value: hours, to: startTime)!
    }
    
    func addHoursToDate(date: Date, hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: date)!
    }
    
    func forecast24hoursTitle(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E dd/MM"
        dateFormatter.locale = getLocale()
        
        let date = dateFormatter.date(from: dateString)!
        
        let titleFormatter = DateFormatter()
        if Locale.current.language.languageCode?.identifier == "ru" {
            titleFormatter.dateFormat = "d MMMM (E)"
        } else {
            titleFormatter.dateFormat = "MMMM, d (E)"
        }
        titleFormatter.locale = getLocale()
        
        return titleFormatter.string(from: date)
    }
    
    func addDaysToStartTime(_ days: Int, timeZoneIdentifier: String?) -> Date {
        let startTime = startTimeDate(timeZoneIdentifier: timeZoneIdentifier)
        
        return Calendar.current.date(byAdding: .day, value: days, to: startTime)!
    }
    
    func currentTimeString(timeZoneIdentifier: String?) -> String {
        let time = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let newDate = Calendar.current.date(bySettingHour: getHours(Date(), timeZoneIdentifier: timeZoneIdentifier), minute: 0, second: 0, of: time) ?? Date()
        
        return dateFormatter.string(from: newDate)
    }
    
    func endDate(timeZoneIdentifier: String?) -> Date {
        Calendar.current.date(byAdding: .day, value: 10, to: addHoursToStartTime(3, timeZoneIdentifier: timeZoneIdentifier))!
    }
    
    func windDirectionText(_ windDirection: Wind.CompassDirection) -> String {
        switch windDirection {
        case .north:
            "N".localized
        case .northNortheast:
            "NNE".localized
        case .northeast:
            "NE".localized
        case .eastNortheast:
            "ENE".localized
        case .east:
            "E".localized
        case .eastSoutheast:
            "ESE".localized
        case .southeast:
            "SE".localized
        case .southSoutheast:
            "SSE".localized
        case .south:
            "S".localized
        case .southSouthwest:
            "SSW".localized
        case .southwest:
            "SW".localized
        case .westSouthwest:
            "WSW".localized
        case .west:
            "W".localized
        case .westNorthwest:
            "WNW".localized
        case .northwest:
            "NW".localized
        case .northNorthwest:
            "NNW".localized
        }
    }
    
    func weatherCondition(_ condition: WeatherCondition) -> String {
        switch condition {
        case .blizzard:
            "Blizzard".localized
        case .blowingDust:
            "Blowing dust".localized
        case .blowingSnow:
            "Blowing snow".localized
        case .breezy:
            "Breezy".localized
        case .clear:
            "Clear".localized
        case .cloudy:
            "Cloudy".localized
        case .drizzle:
            "Drizzle".localized
        case .flurries:
            "Flurries".localized
        case .foggy:
            "Foggy".localized
        case .freezingDrizzle:
            "Freezing drizzle".localized
        case .freezingRain:
            "Freezing rain".localized
        case .frigid:
            "Frigid".localized
        case .hail:
            "Hail".localized
        case .haze:
            "Haze".localized
        case .heavyRain:
            "Heavy rain".localized
        case .heavySnow:
            "Heavy snow".localized
        case .hot:
            "Hot".localized
        case .hurricane:
            "Hurricane".localized
        case .isolatedThunderstorms:
            "Isolated thunderstorms".localized
        case .mostlyClear:
            "Mostly clear".localized
        case .mostlyCloudy:
            "Mostly cloudy".localized
        case .partlyCloudy:
            "Partly cloudy".localized
        case .rain:
            "Rain".localized
        case .scatteredThunderstorms:
            "Scattered thunderstorms".localized
        case .sleet:
            "Sleet".localized
        case .smoky:
            "Smoky".localized
        case .snow:
            "Snow".localized
        case .strongStorms:
            "Strong storms".localized
        case .sunFlurries:
            "Sun flurries".localized
        case .sunShowers:
            "Sun showers".localized
        case .thunderstorms:
            "Thunderstorms".localized
        case .tropicalStorm:
            "Tropical storm".localized
        case .windy:
            "Windy".localized
        case .wintryMix:
            "Wintry mix".localized
        @unknown default:
            ""
        }
    }
    
    func weatherConditionImage(condition: WeatherCondition, isDark: Bool?, isCurrent: Bool?) -> UIImage {
        switch condition {
        case .blizzard:
            UIImage(systemName: "wind.snow")!
        case .blowingDust:
            UIImage(systemName: "sun.dust")!
        case .blowingSnow:
            UIImage(systemName: "wind.snow")!
        case .breezy:
            UIImage(named: "Cold")!
        case .clear:
            if isDark == true {
                if isCurrent == true {
                    UIImage(systemName: "moon.fill")!
                } else {
                    UIImage(named: "CrescentMoon")!
                }
            } else {
                UIImage(named: "Sunny")!
            }
        case .cloudy:
            UIImage(named: "Cloudy")!
        case .drizzle:
            UIImage(named: "Raindrops")!
        case .flurries:
            UIImage(systemName: "wind")!
        case .foggy:
            UIImage(systemName: "cloud.fog.fill")!
        case .freezingDrizzle:
            UIImage(systemName: "cloud.sleet.fill")!
        case .freezingRain:
            UIImage(systemName: "cloud.sleet.fill")!
        case .frigid:
            UIImage(named: "Cold")!
        case .hail:
            UIImage(systemName: "cloud.hail.fill")!
        case .haze:
            UIImage(systemName: "cloud.fog.fill")!
        case .heavyRain:
            UIImage(named: "Rain")!
        case .heavySnow:
            UIImage(systemName: "snowflake")!
        case .hot:
            UIImage(named: "Hot")!
        case .hurricane:
            UIImage(systemName: "hurricane")!
        case .isolatedThunderstorms:
            UIImage(named: "Thunderstorm")!
        case .mostlyClear:
            if isDark == true {
                if isCurrent == true {
                    UIImage(systemName: "moon.fill")!
                } else {
                    UIImage(named: "CrescentMoon")!
                }
            } else {
                UIImage(named: "Sunny")!
            }
        case .mostlyCloudy:
            UIImage(named: "Cloudy")!
        case .partlyCloudy:
            UIImage(named: "Cloudy")!
        case .rain:
            UIImage(named: "Rain")!
        case .scatteredThunderstorms:
            UIImage(named: "Thunderstorm")!
        case .sleet:
            UIImage(systemName: "cloud.sleet.fill")!
        case .smoky:
            UIImage(systemName: "smoke.fill")!
        case .snow:
            UIImage(systemName: "snowflake")!
        case .strongStorms:
            UIImage(systemName: "hurricane")!
        case .sunFlurries:
            UIImage(systemName: "sun.haze.fill")!
        case .sunShowers:
            if isDark == true {
                UIImage(systemName: "cloud.moon.rain.fill")!
            } else {
                UIImage(systemName: "cloud.sun.rain.fill")!
            }
        case .thunderstorms:
            UIImage(named: "Thunderstorm")!
        case .tropicalStorm:
            UIImage(named: "Thunderstorm")!
        case .windy:
            UIImage(systemName: "wind")!
        case .wintryMix:
            UIImage(systemName: "cloud.sleet.fill")!
        @unknown default:
            if isDark == true {
                if isCurrent == true {
                    UIImage(systemName: "moon.fill")!
                } else {
                    UIImage(named: "CrescentMoon")!
                }
            } else {
                UIImage(named: "Sunny")!
            }
        }
    }
    
}
