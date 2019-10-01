//
//  CurrentWeatherViewController.swift
//  WeatherAppData
//
//  Created by Eva on 9/27/19.
//  Copyright © 2019 Eva. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController  {
    private var locManager = CLLocationManager()
    @IBOutlet weak var tableView: UITableView!
    
    private var forecastArray = [List]()
    private var reuseView = WeatherReuseView()
    private var weatherModel : CurrentWeakWeatherModel?
    
    
    private var model : CurrentSingleWeatherModel?
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        locManager.delegate = self
        locManager.requestAlwaysAuthorization()
        self.reuseView = WeatherReuseView()
        self.reuseView.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.size.width-40, height: 300)
        
        self.reuseView.contentMode = .scaleAspectFill
        self.reuseView.clipsToBounds = true
        
        
        tableView.estimatedRowHeight = 50
        tableView.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locManager.startUpdatingLocation()
        if NetworkHelper.isConnected() {
            downloadDetails()
        }
    }
    
    
    private func downloadDetails(){
        
        let latitude = "lat=" + "\(String(describing: locManager.location!.coordinate.latitude))"
        let longitude = "&lon=" + "\(String(describing: locManager.location!.coordinate.longitude))"
        let locationWeatherUrl = latitude + longitude + Config.kWeatherAPIKey
        
        let dispatchGroup = DispatchGroup()
        self.displayActivityIndicator(shouldDisplay: true)
        
        dispatchGroup.enter()
        RequestManager.getCurrentWeatherByWeek(url: Config.kForecastAPI + locationWeatherUrl, completionHandler: { (data) in
            DispatchQueue.main.async {
                
                self.weatherModel = data
                self.forecastArray = self.weatherModel!.list
                dispatchGroup.leave()
            }
        }) { (error) in
            self.displayActivityIndicator(shouldDisplay: false)
            print(error)
        }
        
        
        dispatchGroup.enter()
        RequestManager.getCurrentWeather(url: Config.kCurrentWeatherAPI + locationWeatherUrl, completionHandler: { (data) in
            DispatchQueue.main.async {
                
                self.model = data
                dispatchGroup.leave()
            }
        }) { (error) in
            print(error)
            self.displayActivityIndicator(shouldDisplay: false)
        }
        
        dispatchGroup.notify(queue: .main) {
            
            self.reuseView.setWeatherData(weather: self.model)
            self.view.addSubview(self.reuseView)
            self.reloadTableView()
            self.displayActivityIndicator(shouldDisplay: false)
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    
}

extension CurrentWeatherViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}


extension CurrentWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let forecastCell = tableView.dequeueReusableCell(withIdentifier: "forecastTableCell") as? ForecastTableViewCell {
            return forecastCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let forecastCell = cell as? ForecastTableViewCell else { return }
        let forecast = forecastArray[indexPath.row]
        forecastCell.forecast = forecast
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        let height = min(max(y, 60), 400)
        self.reuseView.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.size.width-40, height: height)
        if height > 60{
            self.reuseView.isHidden = false
        }else{
            self.reuseView.isHidden = true
        }
    }
}
