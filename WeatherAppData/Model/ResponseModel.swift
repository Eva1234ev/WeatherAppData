//
//  ResponseModel.swift
//  WeatherAppData
//
//  Created by Eva on 9/28/19.
//  Copyright © 2019 Eva. All rights reserved.
//

import Foundation

struct ResponseModel<T: Codable>: Codable {
   var data: T?
    var hasError: Bool
    var errors: [Error]
    var statusCode: Int
    
    struct Error: Codable {
        var key: String
        var message: String
    }
}

