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

    weak var delegate: TripManagerDelegate?

    // MARK: - Private properties

    private var previousLocation: CLLocation?
    private var tempSpeed: [Double] = []
    private var tempDistance: [Double] = []
    private var tripData: Trip! = Trip(avgSpeed: 0.0, distance: 0.0)

    private let locationService = LocationService()

    // MARK: - Lifecycle

    init() {
        locationService.delegate = self
    }

    // MARK: - LocationServiceDelegate

    func locationService(_ locationService: LocationService, didUpdateLocation location: CLLocation) {
        
        if let previousLocation = previousLocation {
            tripData.distance = Double(round(location.distance(from: previousLocation)))
        }
        
        previousLocation = location
        
        if previousLocation != location {
         tempDistance.append(round(location.distance(from: previousLocation ?? location))/1000)
        }
        if(location.timestamp > Date.init(timeIntervalSinceNow: -600)){
            tempSpeed.append(abs(location.speed / 1000 * 3600))
//            tempSpeed.append(location.speed)
        }
        previousLocation = location

        print(tempDistance)
        print(tempSpeed)
         
        let sumSpeed = tempSpeed.reduce(0.0, +)
        tripData.avgSpeed = sumSpeed / Double(tempSpeed.count)
        tripData.distance = tempDistance.reduce(0.0, +)

        delegate?.tripDataDidUpdate(trip: tripData);
    }

}
