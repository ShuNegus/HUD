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


    @IBOutlet weak var speedOutput: UILabel!
    @IBOutlet weak var speedUnitsOutput: UILabel!
    
    var speedManager: SpeedManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speedManager = SpeedManager()
        speedManager.delegate = self
    }

}

extension SpeedViewController: SpeedManagerDelegate {
    func speedDidChange(speed: CLLocationSpeed) {
        speedOutput?.text = String(Int(speed))
        speedUnitsOutput?.text = "KM/H"
        print(speed)
    }
}

