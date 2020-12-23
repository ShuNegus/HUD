//
//  SpeedViewController.swift
//  HUD
//
//  Created by Konstantin on 15.12.2020.
//  Copyright © 2020 Konstantin Kuznetsov. All rights reserved.
//

import UIKit
import CoreLocation

class SpeedViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var speedOutput: UILabel!
    @IBOutlet weak var speedUnitsOutput: UILabel!

    // MARK: - Internal properties

    let speedManager = SpeedManager()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speedManager.delegate = self
    }

}

// MARK: - SpeedManagerDelegate

extension SpeedViewController: SpeedManagerDelegate {
    
    func speedDidChange(speed: Measurement<UnitSpeed>) {
        let kmHMesure = speed.converted(to: .kilometersPerHour)
        speedOutput?.text = String(round(kmHMesure.value))
        speedUnitsOutput?.text = "KM/H"
    }
}

