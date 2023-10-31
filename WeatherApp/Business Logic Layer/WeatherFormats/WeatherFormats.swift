//
//  WeatherFormats.swift
//  WeatherApp
//
//  Created by Matsulenko on 07.10.2023.
//

import UIKit
import WeatherKit

extension UIView {
    
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
    
    func timeFormatLong(_ timeString: String) -> String {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "Time12") {
            return timeAmPmLong(timeString)
        } else {
            return timeString
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
    
    func timeAmPmLong(_ twentyFourFormat: String) -> String {
        let dateFormatter24 = DateFormatter()
        dateFormatter24.dateFormat = "HH:mm, E d MMMM"
        dateFormatter24.locale = Locale(identifier: "ru_RU")
        
        let time = dateFormatter24.date(from: twentyFourFormat)!
        
        let dateFormatter12 = DateFormatter()
        dateFormatter12.dateFormat = "h:mm a, E d MMMM"
        dateFormatter12.locale = Locale(identifier: "ru_RU")
        
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
    
    func dateToStringLong(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, E d MMMM"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        return dateFormatter.string(from: date)
    }
    
    func dateToStringShort(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E d"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        return dateFormatter.string(from: date)
    }
    
    func dateToStringMedium(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E dd/MM"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        return dateFormatter.string(from: date).lowercased()
    }
    
    func fullToShort(_ dateString: String?) -> String {
        guard let date = stringToDateFull(dateString) else { return "" }
        
        return dateToStringShort(date)
    }
    
    func dateToStringFull(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        return dateFormatter.string(from: date)
    }
    
    func dateToStringTime(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: date)
    }
    
    func stringToDateFull(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        return dateFormatter.date(from: dateString)
    }
    
    func getHours(_ date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H"
        
        return Int(dateFormatter.string(from: date))!
    }
    
    func startTimeDate() -> Date {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H"
        let hours = getHours(date)
        var newDate = date
        
        switch hours {
        case 3..<6:
            newDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        case 6..<9:
            newDate = Calendar.current.date(bySettingHour: 3, minute: 0, second: 0, of: date)!
        case 9..<12:
            newDate = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: date)!
        case 12..<15:
            newDate = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: date)!
        case 15..<18:
            newDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: date)!
        case 18..<21:
            newDate = Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: date)!
        case 21..<24:
            newDate = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: date)!
        case 0..<3:
            newDate = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: date)!
            newDate = Calendar.current.date(byAdding: .day, value: -1, to: newDate)!
        default:
            newDate = Calendar.current.date(byAdding: .hour, value: -3, to: date)!
        }
        
        return newDate
    }
    
    func startTimeString() -> String {
        let startTime = startTimeDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: startTime)
    }
    
    func endTimeDate() -> Date {
        let startTime = startTimeDate()
        
        return Calendar.current.date(byAdding: .hour, value: 26, to: startTime)!
    }
    
    func addHoursToStartTime(_ hours: Int) -> Date {
        let startTime = startTimeDate()
        
        return Calendar.current.date(byAdding: .hour, value: hours, to: startTime)!
    }
    
    func add3HoursToStartTimeString() -> String {
        let startTime = startTimeDate()
        let newTime = Calendar.current.date(byAdding: .hour, value: 3, to: startTime)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: newTime)
    }
    
    func convertToLocationTimeZone(date: Date, secondsFromGMT: Int?) -> Date {
        let systemTimeZone = Calendar.current.timeZone.secondsFromGMT()
        let difference = (secondsFromGMT ?? systemTimeZone) - systemTimeZone
        
        return Calendar.current.date(byAdding: .second, value: difference, to: date)!
    }
    
    func endDate() -> Date {
        Calendar.current.date(byAdding: .day, value: 10, to: Date())!
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
