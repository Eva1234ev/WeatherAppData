//
//  ForecastTableViewCell.swift
//  WeatherAppData
//
//  Created by Eva on 9/27/19.
//  Copyright © 2019 Eva. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel?
    @IBOutlet weak var lblDescription : UILabel?
    @IBOutlet weak var lblTemp : UILabel?
    @IBOutlet weak var weatherImageView: UIImageView!
    var forecast: List? {
        didSet {
            if let unixTimeStamp = forecast?.dt {
                let date = Date(timeIntervalSince1970: TimeInterval(unixTimeStamp))
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "yyyy MMM,dd HH:mm a"
                let strDate = dateFormatter.string(from: date)
                lblDate?.text = strDate
            }
          
            if let weatherArr = forecast?.weather{
                if weatherArr.count > 0 {
                    let weather = weatherArr[0]
                    lblDescription?.text = weather.weatherDescription
                    let urlImage = "https://openweathermap.org/img/w/" + (weather.icon) + ".png"
                    self.weatherImageView.sd_setImage(with: URL(string: urlImage), placeholderImage: UIImage(systemName: "person.crop.circle"))
                }
            }
            if let main = forecast?.main{
                lblTemp?.text = Utils.getTemperatureInCelcius(kelvin:(main.temp)) + "°" 
            }
            
            
        }
    }
}
