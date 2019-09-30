//
//  Utils.swift
//  WeatherAppData
//
//  Created by Eva on 9/28/19.
//  Copyright © 2019 Eva. All rights reserved.
//

import Foundation

class Utils {

    static func getTemperatureInCelcius(kelvin: Double) -> String {
        let celsiusTemp = kelvin - 273.15
        return String(format: "%.0f", celsiusTemp) + "℃"
    }
    
}
