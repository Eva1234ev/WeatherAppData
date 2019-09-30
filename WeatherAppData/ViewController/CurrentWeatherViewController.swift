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
   
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        locManager.delegate = self
        locManager.requestAlwaysAuthorization()
        
        self.reuseView = WeatherReuseView()
        self.reuseView.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.size.width-40, height: 300)
      
        self.reuseView.contentMode = .scaleAspectFill
        self.reuseView.clipsToBounds = true
        self.view.addSubview(self.reuseView)
        
        tableView.estimatedRowHeight = 50
        tableView.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locManager.startUpdatingLocation()
        
    }
    
    private func createUrl()->String{
        
        let latitude = "lat=" + "\(String(describing: locManager.location!.coordinate.latitude))"
        let longitude = "&lon=" + "\(String(describing: locManager.location!.coordinate.longitude))"
        
        return latitude + longitude
    }
    
    
    func getWeatherForecast() {
        displayActivityIndicator(shouldDisplay: true)

        let requestURL = Config.kForecastAPI + self.createUrl() + Config.kWeatherAPIKey
        RequestManager.getCurrentWeatherByWeek(url: requestURL, completionHandler: { (data) in
                 self.weatherModel = data
            self.displayActivityIndicator(shouldDisplay: false)

                 self.forecastArray = self.weatherModel!.list
                 self.reloadTableView()
              }) { (error) in
                self.displayActivityIndicator(shouldDisplay: false)
                  print(error)
              }
        //let t = AnyObject()
//        APIClient.sharedInstance.fetchDictionaryDataWithGetRequest(requestUrl: requestURL, headers: [:]) { (error, response) in
//                 //self.loader?.stopAnimating()
//
//                 if error != nil {
//                     print("Error")
//                     return
//                 }
//            self.weatherModel = response as! CurrentWeakWeatherModel
//
    }
        func reloadTableView() {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
        
        
    }

    extension CurrentWeatherViewController : CLLocationManagerDelegate {
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            if NetworkHelper.isConnected() {
                self.reuseView.updateCurrentWeather(urlLocation: self.createUrl())
                getWeatherForecast()
            }
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
            
        }
}
