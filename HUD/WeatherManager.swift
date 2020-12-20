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
    // Синтаксис делегата по заветам apple
    func weatherManager(_ weatherManager: WeatherManager, didUpdate temperature: String)
    // Error лучше работать со свифтовой Error
    func weatherManager(_ weatherManager: WeatherManager, didRecive error: String)
}

class WeatherManager: LocationServiceDelegate {

    // MARK: - Internal properties

    var delegate: WeatherDelegate?

    // MARK: - Private properties
    
    private let locationService = LocationService()
    
    private let weatherBaseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "75370c7adc83f96bc66ddf9e42096d9f"

//    // Используем простые конструкторы
//    private var temperature = ""

    private var location: CLLocation?
    // Он будет обновлять погоду с заданым промежутком времени
    private var timer: Timer?

    private var didWeatherFirstCall = false

    // Конструктор всегда выше функций
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

        // Вот это бы все декомпозировать на отдельные методы: Создать урл, кинуть реквест, смапить данные.
        // На счет мапинга лучше юзать codable https://habr.com/ru/post/414221/

        let weatherURL = URL(string: "\(weatherBaseURL)?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)")!
        print(String("\(weatherBaseURL)?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)"))
        /// Типы данных в клоужуре (data: Data?, response: URLResponse?, error: Error?) раскрывать не нужно, и не забываем убрать утечку памяти [weak self]
        let dataTask = session.dataTask(with: weatherURL) { [weak self] data, response, error in
            // Захватываем self
            guard let self = self else {
                return
            }
            // Куча вложенных if-ов, подумай как можно решить через guard
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

    /*
    // Метод не может возвращать данные, т.к. сетевой запрос ассинхронный, нужен callback через клоужуру
    func getTemperature(location: CLLocation) -> String {
        
        let session = URLSession.shared

        // Вот это бы все декомпозировать на отдельные методы: Создать урл, кинуть реквест, смапить данные.
        // На счет мапинга лучше юзать codable https://habr.com/ru/post/414221/

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
    */

    // MARK: - LocationServiceDelegate

    func locationService(_ locationService: LocationService, didUpdateLocation location: CLLocation) {
        self.location = location
        if didWeatherFirstCall == false {
            didWeatherFirstCall = true
            updateWeather()
        }
    }
}
