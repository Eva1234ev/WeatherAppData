//
//  WeatherReuseView.swift
//  WeatherAppData
//
//  Created by Eva on 9/28/19.
//  Copyright © 2019 Eva. All rights reserved.
//

import UIKit

class WeatherReuseView: UIView {
    
    let kCONTENT_XIB_NAME = "WeatherReuseView"
    @IBOutlet var contentView: UIView!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var cloudsLabel:UILabel!;
    @IBOutlet var windSpeedLabel:UILabel!;
    @IBOutlet var windDirection:UILabel!;
    @IBOutlet var humidityLabel:UILabel!;
    @IBOutlet var pressureLabel:UILabel!;
    @IBOutlet weak var weatherImageView: UIImageView!
    private var model : CurrentSingleWeatherModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        self.weatherImageView.layer.cornerRadius =  self.weatherImageView.frame.height/2
        self.weatherImageView.layer.masksToBounds = true
        
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = true
    }

    func setWeatherData(weather: CurrentSingleWeatherModel?) {
        self.temperatureLabel.text =  Utils.getTemperatureInCelcius(kelvin: (weather?.main.temp)!) + "°" ;
        self.pressureLabel?.text = "Pressure (Atmsp.) - " + String((weather?.main.pressure)!) + " mbar"
        self.humidityLabel?.text = "Humidity - " + String(Int((weather?.main.humidity)!)) + "%"
        
        if let speed = weather?.wind.speed {
            self.windSpeedLabel?.text = "Wind Speed - " + String(speed) + " km/h"
        }
        if let deg = weather?.wind.deg {
            self.windDirection?.text = "Wind Direction - " + self.toTextualDescription(degree: deg)
        }
        if let cloudsText = weather?.clouds.all {
            self.cloudsLabel?.text = "Cloud - " + String(cloudsText)  + "%"
        }
        else{
            self.cloudsLabel?.text = "Cloud -  0%"
        }
        
        self.countryLabel?.text = weather?.name
        let urlImage = "https://openweathermap.org/img/w/" + (weather?.weather[0].icon)! + ".png"
        self.weatherImageView.sd_setImage(with: URL(string: urlImage), placeholderImage: UIImage(systemName: "person.crop.circle"))
        self.descriptionLabel?.text = (weather?.weather[0].weatherDescription)!
    }
    
    
    func toTextualDescription(degree:Double)->String{
        if(degree>337.5){ return "Northerly"}
        if(degree>292.5) {return "North Westerly"}
        if(degree>247.5) {return "Westerly"}
        if(degree>202.5) {return "South Westerly"}
        if(degree>157.5) {return "Southerly"}
        if(degree>122.5) {return "South Easterly"}
        if(degree>67.5) {return "asterly"}
        if(degree>22.5) {return "North Easterly"}
        return "Northerly";
    }
    
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
