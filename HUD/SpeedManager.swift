//
//  SpeedManager.swift
//  HUD
//
//  Created by Konstantin on 09/12/2020.
//  Copyright © 2020 Konstantin Kuznetsov. All rights reserved.
//

import UIKit
import CoreLocation

protocol SpeedManagerDelegate: class {
    func speedDidChange(speed: CLLocationSpeed)
}

class SpeedManager: NSObject, CLLocationManagerDelegate {
    
    weak var delegate: SpeedManagerDelegate?
    
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways{
            locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let kmph = max(locations[locations.count - 1].speed / 1000 * 3600, 0);
            delegate?.speedDidChange(speed: kmph);
            
        }
        
    }

}
