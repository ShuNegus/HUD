//
//  WeatherManager.swift
//  HUD
//
//  Created by Konstantin on 13/12/2020.
//  Copyright © 2020 Konstantin Kuznetsov. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherDelegate: class {
    func weatherDidUpdate(temperature: String)
}

class WeatherManager: NSObject, CLLocationManagerDelegate {
    var delegate: WeatherDelegate?
    
    private let locationManager: CLLocationManager?
    
    private let weatherBaseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "75370c7adc83f96bc66ddf9e42096d9f"
    var temperature = String()
    func getTemperature(location: CLLocation) -> String{
        
        let session = URLSession.shared

        let weatherURL = URL(string: "\(weatherBaseURL)?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)")!
        print(String("\(weatherBaseURL)?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)"))
        let dataTask = session.dataTask(with: weatherURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            print("Error:\n\(error)")
        } else {
            if let data = data {
                if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                    if let mainDictionary = jsonObj.value(forKey: "main") as? NSDictionary {
                        if let temperatureTemp = mainDictionary.value(forKey: "temp") {
                            self.temperature = String("\(temperatureTemp)")
                        }
                    } else {
                        print("Error: unable to find temperature in dictionary")
                        self.temperature = "Error: unable to find temperature in dictionary"
                    }
                } else {
                    print("Error: unable to convert json data")
                    self.temperature = "Error: unable to convert json data"
                }
            } else {
                print("Error: did not receive data")
                self.temperature = "Error: did not receive data"
            }
        }
        }
        dataTask.resume()
        return temperature
    }
    
    override init() {
        locationManager = CLLocationManager.locationServicesEnabled() ? CLLocationManager() : nil
        
        super.init()
        
        if let locationManager = self.locationManager {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse{
                locationManager.startUpdatingLocation()
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse{
            locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let temperature = self.getTemperature(location: locations.last!)
            delegate?.weatherDidUpdate(temperature: temperature)
            print(temperature + " in location manager")
        }
    }
}
