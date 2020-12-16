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
    var tempSpeed: [Double]?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
    
        let lastLocation = locations.last!
        
        if let previousLocation = previousLocation {
            tripData.distance = Double(round(lastLocation.distance(from: previousLocation)))
        }
        
        previousLocation = lastLocation
        
        for location in locations {
            if(location.timestamp > Date.init(timeIntervalSinceNow: -600)){
                tempSpeed?.append(location.speed)
            }
        }
            
        let sumSpeed = tempSpeed?.reduce(0.0, +) ?? 0.0
        tripData.avgSpeed = sumSpeed / Double(tempSpeed?.count ?? 1)
        
        delegate?.tripDataDidUpdate(trip: tripData);
    }
    

}
