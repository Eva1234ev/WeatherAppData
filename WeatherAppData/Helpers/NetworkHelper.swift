//
//  NetworkHelper.swift
//  WeatherAppData
//
//  Created by Eva on 9/28/19.
//  Copyright © 2019 Eva. All rights reserved.
//

import Foundation
import Alamofire

class NetworkHelper {
    class func isConnected() -> Bool {
        return (NetworkReachabilityManager()?.isReachable)! 
    }
}
