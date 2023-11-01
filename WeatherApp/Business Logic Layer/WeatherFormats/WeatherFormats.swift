//
//  WeatherFormats.swift
//  WeatherApp
//
//  Created by Matsulenko on 07.10.2023.
//

import UIKit
import WeatherKit

extension UIView {
    
    func getLocale() -> Locale {
        Locale(identifier: "ru_RU")
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
        dateFormatter.locale = getLocale()
        let updateTime = dateFormatter.date(from: timeString)!
        
        if updateTime.timeIntervalSinceNow >= -600 {
            return "Обновлено сейчас"
        } else {
            if defaults.bool(forKey: "Time12") {
                return timeAmPmLong(timeString, timeZoneIdentifier: timeZoneIdentifier).lowercased()
            } else {
                let dateFormatter24 = DateFormatter()
                dateFormatter24.dateFormat = "HH:mm, E d MMMM"
                dateFormatter24.timeZone = TimeZone(identifier: timeZoneIdentifier ?? Calendar.current.timeZone.identifier)
                dateFormatter24.locale = getLocale()
                
                return dateFormatter24.string(from: updateTime).lowercased()
            }
        }
    }
    
    func windSuffixMain() -> String {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "WindSpeedInMi") {
            return "ми\\ч"
        } else {
            return "м\\с"
        }
    }
    
    func windSuffixTable() -> String {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "WindSpeedInMi") {
            return "mph"
        } else {
            return "m/s"
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
        dateFormatter24.locale = getLocale()
        
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
        dateFormatter.locale = getLocale()
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier ?? Calendar.current.timeZone.identifier)
        
        return dateFormatter.string(from: date)
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
        
        return dateFormatter.string(from: date).lowercased()
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
    
    func fullDateAndDayWithOffset(offset: Int?, timeZoneIdentifier: String?) -> String {
        let date = addDaysToStartTime(offset ?? 0, timeZoneIdentifier: timeZoneIdentifier)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM (E)"
        dateFormatter.locale = getLocale()
        
        return dateFormatter.string(from: date)
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
            "С"
        case .northNortheast:
            "ССВ"
        case .northeast:
            "СВ"
        case .eastNortheast:
            "ВСВ"
        case .east:
            "В"
        case .eastSoutheast:
            "ВЮВ"
        case .southeast:
            "ЮВ"
        case .southSoutheast:
            "ЮЮВ"
        case .south:
            "Ю"
        case .southSouthwest:
            "ЮЮЗ"
        case .southwest:
            "ЮЗ"
        case .westSouthwest:
            "ЗЮЗ"
        case .west:
            "З"
        case .westNorthwest:
            "ЗСЗ"
        case .northwest:
            "СЗ"
        case .northNorthwest:
            "ССЗ"
        }
    }
    
    func weatherCondition(_ condition: WeatherCondition) -> String {
        switch condition {
        case .blizzard:
            "Метель"
        case .blowingDust:
            "Песчаная буря"
        case .blowingSnow:
            "Снежная буря"
        case .breezy:
            "Свежесть"
        case .clear:
            "Ясно"
        case .cloudy:
            "Облачно"
        case .drizzle:
            "Моросящий дождь"
        case .flurries:
            "Шквалы"
        case .foggy:
            "Туман"
        case .freezingDrizzle:
            "Моросящий ледяной дождь"
        case .freezingRain:
            "Ледяной дождь"
        case .frigid:
            "Холод"
        case .hail:
            "Град"
        case .haze:
            "Лёгкий туман"
        case .heavyRain:
            "Ливень"
        case .heavySnow:
            "Снегопад"
        case .hot:
            "Жара"
        case .hurricane:
            "Ураган"
        case .isolatedThunderstorms:
            "Местами грозы"
        case .mostlyClear:
            "Преимущественно ясно"
        case .mostlyCloudy:
            "Преимущественно облачно"
        case .partlyCloudy:
            "Переменная облачность"
        case .rain:
            "Дождь"
        case .scatteredThunderstorms:
            "Возможны грозы"
        case .sleet:
            "Мокрый снег"
        case .smoky:
            "Дымка"
        case .snow:
            "Снег"
        case .strongStorms:
            "Сильные штормы"
        case .sunFlurries:
            "Солнечные шквалы"
        case .sunShowers:
            "Грибной дождь"
        case .thunderstorms:
            "Гроза"
        case .tropicalStorm:
            "Тропическая буря"
        case .windy:
            "Ветрено"
        case .wintryMix:
            "Дождь со снегом"
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
