//
//  Configuration.swift
//  WeatherAppData
//
//  Created by Eva on 9/28/19.
//  Copyright © 2019 Eva. All rights reserved.
//

import Foundation

struct Config {
    //APIKey = "a28594d3377e9f55a918b16a30100b16"
    static  let kWeatherAPIKey = "&APPID=a28594d3377e9f55a918b16a30100b16"
    static  let kBaseURL = "http://api.openweathermap.org/data/2.5/"
    static  let kCurrentWeatherAPI = kBaseURL + "weather?"
    static  let kForecastAPI = kBaseURL + "forecast?"
    static  let kAllCountriesAPI = "https://restcountries.eu/rest/v2/all"
}
