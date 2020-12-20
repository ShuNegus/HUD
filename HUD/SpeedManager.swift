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
    func speedDidChange(speed: Measurement<UnitSpeed>)
}

class SpeedManager: LocationServiceDelegate {

    // MARK: - Internal properties
    
    weak var delegate: SpeedManagerDelegate?

    // MARK: - Private properties
    private let locationService = LocationService()
    

    // MARK: - Lifecycle
    
    init() {
        locationService.delegate = self
    }

    // MARK: - LocationServiceDelegate

    func locationService(_ locationService: LocationService, didUpdateLocation location: CLLocation) {
        delegate?.speedDidChange(speed: .init(value: location.speed, unit: .metersPerSecond))
    }
}
