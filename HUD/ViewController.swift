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

    // MARK: - IBOutlets

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tripContainerView: UIView!
    @IBOutlet weak var weatherContainerView: UIView!

    // MARK: - Internal properties

    let tripViewController = TripViewController()
    let speedViewController = SpeedViewController()
    let weatherViewController = WeatherViewController()
    let graphicSpeed = GraphicSpeedViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        addChild(vc: speedViewController, to: containerView)
        addChild(vc: tripViewController, to: tripContainerView)
        addChild(vc: weatherViewController, to: weatherContainerView)
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .left
        {
            addChild(vc: graphicSpeed, to: containerView)
        }

        if sender.direction == .right
        {
            addChild(vc: speedViewController, to: containerView)
        }
    }
}

