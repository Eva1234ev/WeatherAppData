//
//  AppGlobal.swift
//  WeatherAppData
//
//  Created by Eva on 9/28/19.
//  Copyright © 2019 Eva. All rights reserved.
//


import Foundation

typealias CompletionHandler<T> = (_ data: T)->()
typealias ErrorHandler = (_ error: Error)->()

struct CustomError: LocalizedError {
    let errorDescription: String?
}
