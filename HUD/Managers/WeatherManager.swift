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
    
    func weatherManager(_ weatherManager: WeatherManager, didUpdate temperature: String)
    
    func weatherManager(_ weatherManager: WeatherManager, didRecive error: String)
}

class WeatherManager: LocationServiceDelegate {

    // MARK: - Internal properties

    var delegate: WeatherDelegate?

    // MARK: - Private properties
    
    private let locationService = LocationService()
    
    private let weatherBaseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "75370c7adc83f96bc66ddf9e42096d9f"

    private var location: CLLocation?
    // Он будет обновлять погоду с заданым промежутком времени
    private var timer: Timer?

    private var didWeatherFirstCall = false

    // MARK: - Lifecycle

    init() {
        locationService.delegate = self
        timer = Timer.scheduledTimer(
            timeInterval: 30,
            target: self,
            selector: #selector(updateWeather),
            userInfo: nil,
            repeats: true
        )
    }

    @objc
    func updateWeather() {
        guard let location = location else {
            return
        }

        let session = URLSession.shared

        

        let weatherURL = URL(string: "\(weatherBaseURL)?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)")!
        print(String("\(weatherBaseURL)?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)"))
        
        let dataTask = session.dataTask(with: weatherURL) { [weak self] data, response, error in
        
            guard let self = self else {
                return
            }
        
            if let error = error {
                self.delegate?.weatherManager(self, didRecive: error.localizedDescription)
            } else {
                if let data = data {
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                        if let mainDictionary = jsonObj.value(forKey: "main") as? NSDictionary {
                            if let temperatureTemp = mainDictionary.value(forKey: "temp") {
                                self.delegate?.weatherManager(self, didUpdate: "\(temperatureTemp)")
                            }
                        } else {
                            self.delegate?.weatherManager(self, didRecive: "Error: unable to find temperature in dictionary")
                        }
                    } else {
                        self.delegate?.weatherManager(self, didRecive: "Error: unable to convert json data")
                    }
                } else {
                    self.delegate?.weatherManager(self, didRecive: "Error: did not receive data")
                }
            }
        }
        dataTask.resume()
    }

    // MARK: - LocationServiceDelegate

    func locationService(_ locationService: LocationService, didUpdateLocation location: CLLocation) {
        self.location = location
        if didWeatherFirstCall == false {
            didWeatherFirstCall = true
            updateWeather()
        }
    }
}
