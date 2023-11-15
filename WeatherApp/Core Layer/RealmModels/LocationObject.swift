//
//  LocationObject.swift
//  WeatherApp
//
//  Created by Matsulenko on 08.10.2023.
//

import RealmSwift

final class LocationObject: Object {
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var name: String?
    @Persisted var timeZoneIdentifier: String?
    
    override class func primaryKey() -> String? {
        "name"
    }
    
    convenience init(location: Location) {
        self.init()
        latitude = location.latitude
        longitude = location.latitude
        name = location.name
        timeZoneIdentifier = location.timeZoneIdentifier
    }
}
