//
//  Localized.swift
//  WeatherApp
//
//  Created by Matsulenko on 15.11.2023.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "-")
    }
    
    func localized(_ arg: CVarArg) -> String {
        return String(format: localized, arg)
    }
}
