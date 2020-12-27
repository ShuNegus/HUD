//
//  GraphicSpeedViewController.swift
//  HUD
//
//  Created by Konstantin on 03/12/2020.
//  Copyright © 2020 Konstantin Kuznetsov. All rights reserved.
//

import UIKit
import CoreGraphics

class GraphicSpeedViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var graphLabel: UIView!
    
    // MARK: - Internal properties
    let speedManager = SpeedManager()
    var test = GaugeView()
    //local property
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speedManager.delegate = self
        
        test = GaugeView(frame: CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height))
        graphLabel.addSubview(test)
        
    }
    
}
// MARK: - SpeedManagerDelegate

extension GraphicSpeedViewController: SpeedManagerDelegate {
    
    func speedDidChange(speed: Measurement<UnitSpeed>) {
        let kmHMesure = speed.converted(to: .kilometersPerHour)
        UIView.animate(withDuration:1){
            self.test.value = round(kmHMesure.value)
        }
        print(abs(kmHMesure.value))
//        speedOutput?.text = String(kmHMesure.value)
//        speedUnitsOutput?.text = "KM/H"
    }

}
