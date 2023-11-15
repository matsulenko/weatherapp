//
//  Location.swift
//  WeatherApp
//
//  Created by Matsulenko on 09.10.2023.
//

import Foundation

struct Location {
    let latitude: Double
    let longitude: Double
    let name: String?
    let timeZoneIdentifier: String?
    
    var keyedValues: [String: Any] {
        [
            "latitude": latitude,
            "longitude": longitude,
            "name": name ?? "",
            "timeZoneIdentifier": timeZoneIdentifier ?? Calendar.current.timeZone.identifier
        ]
    }
    
    init(latitude: Double, longitude: Double, name: String?, timeZoneIdentifier: String?) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.timeZoneIdentifier = timeZoneIdentifier
    }
}
