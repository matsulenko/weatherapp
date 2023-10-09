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
    
    var keyedValues: [String: Any] {
        [
            "latitude": latitude,
            "longitude": longitude,
            "name": name ?? ""
        ]
    }
    
    init(latitude: Double, longitude: Double, name: String?) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
}
