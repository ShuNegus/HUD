//
//  TripViewController.swift
//  HUD
//
//  Created by Konstantin on 07/12/2020.
//  Copyright © 2020 Konstantin Kuznetsov. All rights reserved.
//

import UIKit

class TripViewController: UIViewController{

    // MARK: - IBOutlets
    
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    // MARK: - Internal properties
    
    let tripManager = TripManager()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tripManager.delegate = self
    }
}

// MARK: - SpeedManagerDelegate

extension TripViewController: TripManagerDelegate {

    func tripDataDidUpdate(trip: Trip) {
        avgSpeedLabel?.text = String(trip.avgSpeed)
        distanceLabel?.text = String(trip.distance)
        
    }
}

