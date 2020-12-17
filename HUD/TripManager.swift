//
//  TripManager.swift
//  HUD
//
//  Created by Konstantin on 12/12/2020.
//  Copyright © 2020 Konstantin Kuznetsov. All rights reserved.
//

import UIKit
import CoreLocation


protocol TripManagerDelegate: class {
    func tripDataDidUpdate(trip: Trip)
}

class TripManager: NSObject, CLLocationManagerDelegate{
    var delegate: TripManagerDelegate?
    var tripData: Trip! = Trip()
    var previousLocation: CLLocation?
    var tempSpeed: [Double]? = []
    var tempDistance: [Double]? = []
    private let locationManager: CLLocationManager?
    override init() {
        locationManager = CLLocationManager.locationServicesEnabled() ? CLLocationManager() : nil
        
        super.init()
        
        if let locationManager = self.locationManager {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
                locationManager.startUpdatingLocation()
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
    
//        let lastLocation = locations.last!
//
//        if let previousLocation = previousLocation {
//            tripData.distance = Double(round(lastLocation.distance(from: previousLocation)/1000))
//            print(lastLocation.distance(from: previousLocation))
//            print(tripData.distance / 1000)
//        }
        
//        previousLocation = lastLocation
        
        for location in locations {
            
            if previousLocation != location {
                tempDistance?.append(round(location.distance(from: previousLocation ?? location))/1000)
            }
            if(location.timestamp > Date.init(timeIntervalSinceNow: -600)){
                tempSpeed?.append(abs(location.speed / 1000 * 3600))
            }
            previousLocation = location
        }
        print(tempDistance)
        print(tempSpeed)
        let sumSpeed = tempSpeed?.reduce(0.0, +) ?? 0.0
        tripData.avgSpeed = sumSpeed / Double(tempSpeed?.count ?? 1)
        tripData.distance = tempDistance?.reduce(0.0, +) ?? 0.0
        
        delegate?.tripDataDidUpdate(trip: tripData);
    }
    

}
