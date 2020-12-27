//
//  LocationService.swift
//  HUD
//
//  Created by Konstantin on 02/12/2020.
//  Copyright © 2020 Konstantin Kuznetsov. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: class {
    
    func locationService(_ locationService: LocationService, didUpdateLocation location: CLLocation)
}


class LocationService: NSObject, CLLocationManagerDelegate {

    // MARK: - Internal properties

    weak var delegate: LocationServiceDelegate?

    // MARK: - Private properties

    private let locationManager: CLLocationManager

    // MARK: - Lifecycle

    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self

        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()

        case .denied, .notDetermined, .restricted:
            
            locationManager.requestWhenInUseAuthorization()

        @unknown default:
            break
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()

        case .denied, .notDetermined, .restricted:
            break

        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else {
                return
            }
            delegate?.locationService(self, didUpdateLocation: location)
        }
}
