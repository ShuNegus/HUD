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

class TripManager: LocationServiceDelegate {

    // MARK: - Internal properties

    //Делегаты всегда weak
    weak var delegate: TripManagerDelegate?

    // MARK: - Private properties

    private var previousLocation: CLLocation?
    // Пустые массивы безсмысслены
    private var tempSpeed: [Double] = []

    private let locationService = LocationService()

    // MARK: - Lifecycle

    init() {
        locationService.delegate = self
    }

    // MARK: - LocationServiceDelegate

    func locationService(_ locationService: LocationService, didUpdateLocation location: CLLocation) {
        var distance = 0.0
        if let previousLocation = previousLocation {
            // Тут считается дистанция только межу двумя точками а не по всему маршруту, так точно надо?
            distance = Double(round(location.distance(from: previousLocation)))
        }
        previousLocation = location

        tempSpeed.append(location.speed)

        var avgSpeed = 0.0
        if tempSpeed.isEmpty == false {
            let sumSpeed = tempSpeed.reduce(0.0, +)
            avgSpeed = sumSpeed / Double(tempSpeed.count)
        }
        delegate?.tripDataDidUpdate(trip: .init(avgSpeed: avgSpeed, distance: distance))
    }

    /*

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){

     // Force unwrap это очень плохо, старайся его избегать
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

     */
}
