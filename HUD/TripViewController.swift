//
//  TripViewController.swift
//  HUD
//
//  Created by Konstantin on 07/12/2020.
//  Copyright © 2020 Konstantin Kuznetsov. All rights reserved.
//

import UIKit

class TripViewController: UIViewController{
    
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var tripManager: TripManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tripManager = TripManager()
        tripManager.delegate = self
        
    }
}

extension TripViewController: TripManagerDelegate {
    func tripDataDidUpdate(trip: Trip){
        avgSpeedLabel?.text = String(trip.avgSpeed)
        distanceLabel?.text = String(trip.distance)
        
    }
}

