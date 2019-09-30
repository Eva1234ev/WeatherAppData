//
//  RequestManager.swift
//  WeatherAppData
//
//  Created by Eva on 9/28/19.
//  Copyright © 2019 Eva. All rights reserved.
//

import UIKit

final class RequestManager: NSObject {


    static func getCurrentWeather(url: String, completionHandler: @escaping CompletionHandler<CurrentSingleWeatherModel>, errorHandler: @escaping ErrorHandler) {
         var string = url
         string = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
         let requrl = URL(string: string)
         URLSession.shared.executeTask(with: requrl!, httpMethod: .get) { data, response, error in
                   check(data: data, response: response, error: error, completionHandler: { (data) in
                       data?.decodeToJSON(with: CurrentSingleWeatherModel.self, completionHandler: completionHandler, errorHandler: errorHandler)
                   }
                       , errorHandler: errorHandler)
                   
               }
               .resume()
       }

    
  static func getCurrentWeatherByWeek(url: String, completionHandler: @escaping CompletionHandler<CurrentWeakWeatherModel>, errorHandler: @escaping ErrorHandler) {
            let requestUrl = URL(string: url)!
            URLSession.shared.executeTask(with: requestUrl, httpMethod: .get) { data, response, error in
                check(data: data, response: response, error: error, completionHandler: { (data) in
                  data?.decodeToJSON(with: CurrentWeakWeatherModel.self, completionHandler: completionHandler, errorHandler: errorHandler)

                }
                    , errorHandler: errorHandler)
                
            }
            .resume()
                
        }
    static func getAllcountries (url: String, completionHandler: @escaping CompletionHandler<CountryData>, errorHandler: @escaping ErrorHandler) {
              let requestUrl = URL(string: url)!
              URLSession.shared.executeTask(with: requestUrl, httpMethod: .get) { data, response, error in
                  check(data: data, response: response, error: error, completionHandler: { (data) in
                      data?.decodeToJSON(with: CountryData.self, completionHandler: completionHandler, errorHandler: errorHandler)
                  }
                      , errorHandler: errorHandler)
                  
              }
              .resume()
          }

    private static func check(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (Data?) -> Void, errorHandler: ErrorHandler) {
          if let error = error {
              errorHandler(error)
          } else if let data = data {
              completionHandler(data)
          } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
              errorHandler(CustomError(errorDescription: HTTPURLResponse.localizedString(forStatusCode: statusCode)))
          } else {
              errorHandler(CustomError(errorDescription: "Unknown Error"))
          }
      }

}
