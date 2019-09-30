//
//  Data.swift
//  WeatherAppData
//
//  Created by Eva on 9/28/19.
//  Copyright © 2019 Eva. All rights reserved.
//

import Foundation

extension Data {
    
    func decodeToJSON<T: Decodable>(with type: T.Type, completionHandler: CompletionHandler<T>, errorHandler: ErrorHandler) {
        do {
            let json = try JSONDecoder().decode(T.self, from: self)
            completionHandler(json)
        } catch {
            errorHandler(error)
        }
    }
    
    func decodeResponseToJSON<T: Codable>(with type: T.Type, completionHandler: CompletionHandler<T>, errorHandler: ErrorHandler) {
        do {
            let json = try JSONDecoder().decode(ResponseModel<T>.self, from: self)
            if json.hasError {
                var errorString: String?
                json.errors.forEach { (error) in
                    if errorString == nil {
                        errorString = error.message
                    } else {
                        errorString! += ", " + error.message
                    }
                }
                errorHandler(CustomError(errorDescription: errorString))
            } else if let data = json.data {
                completionHandler(data)
            } else {
                errorHandler(CustomError(errorDescription: "Unknown Error"))
            }
        } catch {
            print(error)
            errorHandler(error)
        }
    }
    
    func convertToJSON() -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments)
        } catch {
            print("JSONSerialization error ---------- ", error.localizedDescription)
        }
        return nil
    }
    
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
