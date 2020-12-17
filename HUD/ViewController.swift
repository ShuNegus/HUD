//
//  ViewController.swift
//  HUD
//
//  Created by Konstantin on 02/12/2020.
//  Copyright © 2020 Konstantin Kuznetsov. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController{
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tripContainerView: UIView!
    @IBOutlet weak var weatherContainerView: UIView!
    
    var tripViewController = TripViewController()
    var speedViewController = SpeedViewController()
    var weatherViewController = WeatherViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(speedViewController)
        speedViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        speedViewController.view.frame = containerView.bounds
        containerView.addSubview(speedViewController.view)
        //containerView.transform = CGAffineTransform(scaleX: 1, y: -1)
        speedViewController.didMove(toParent: self)
        
        addChild(tripViewController)
        tripViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tripViewController.view.frame = tripContainerView.bounds
        tripContainerView.addSubview(tripViewController.view)
        tripViewController.didMove(toParent: self)
        
        
        addChild(weatherViewController)
        weatherViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        weatherViewController.view.frame = weatherContainerView.bounds
        weatherContainerView.addSubview(weatherViewController.view)
        weatherViewController.didMove(toParent: self)


        
    }
    
}
