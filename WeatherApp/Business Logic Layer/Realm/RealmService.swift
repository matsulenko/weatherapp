//
//  RealmService.swift
//  WeatherApp
//
//  Created by Matsulenko on 09.10.2023.
//

import Foundation
import RealmSwift


final class RealmService {
    func saveLocation(_ location: Location) {
        do {
            let realm = try Realm()
            
            let handler: () -> Void = {
                realm.create(LocationObject.self, value: location.keyedValues, update: .all)
            }
            
            if realm.isInWriteTransaction {
                handler()
            } else {
                try realm.write {
                    handler()
                }
            }
        } catch {
            fatalError()
        }
    }
    
    func saveWeatherForecastDaily(_ weatherForecastDaily: WeatherForecastDaily) {
        do {
            let realm = try Realm()
            
            let handler: () -> Void = {
                realm.create(WeatherForecastDailyObject.self, value: weatherForecastDaily.keyedValues, update: .all)
            }
            
            if realm.isInWriteTransaction {
                fatalError()
            } else {
                try realm.write {
                    handler()
                }
            }
        } catch {
            fatalError()
        }
    }
    
    func saveWeatherForecastHourly(_ weatherForecastHourly: WeatherForecastHourly) {
        do {
            let realm = try Realm()
            
            let handler: () -> Void = {
                realm.create(WeatherForecastHourlyObject.self, value: weatherForecastHourly.keyedValues, update: .all)
            }
            
            if realm.isInWriteTransaction {
                handler()
            } else {
                try realm.write {
                    handler()
                }
            }
        } catch {
            fatalError()
        }
    }
    
    func saveWeatherForecastCurrent(_ weatherForecastCurrent: WeatherForecastCurrent) {
        do {
            let realm = try Realm()
            
            let handler: () -> Void = {
                realm.create(WeatherForecastCurrentObject.self, value: weatherForecastCurrent.keyedValues, update: .all)
            }
            
            if realm.isInWriteTransaction {
                handler()
            } else {
                try realm.write {
                    handler()
                }
            }
        } catch {
            fatalError()
        }
    }
}
