//
//  LocationService.swift
//  HUD
//
//  Created by Vladimir Shutov on 17.12.2020.
//  Copyright © 2020 Konstantin Kuznetsov. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: class {
    // Обрати внимание на оформление метода, подобные штуки лучше оформлять как рекомендует эппл, например UITableViewDelegate
    func locationService(_ locationService: LocationService, didUpdateLocation location: CLLocation)
}

// Обратил внимание, что работа с локацией больше чем в одном месте, по тому выносим ее в сервис
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

        // Если есть enum, его в 90% случаев лучше проверять через switch
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()

        case .denied, .notDetermined, .restricted:
            // По хорошему надо предусмотреть кейс когда пользователь отказал, и нам надо его отправиь в настроки приложения, что бы он разрешил GPS
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
