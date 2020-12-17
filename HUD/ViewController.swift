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

    // Помечаем марками разделы класса. Соблюдаем код стайл и аккуратность
    // MARK: - IBOutlets

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tripContainerView: UIView!
    @IBOutlet weak var weatherContainerView: UIView!

    // MARK: - Internal properties

    // Это неизменяемые переменные, помечаем их константами
    let tripViewController = TripViewController()
    let speedViewController = SpeedViewController()
    let weatherViewController = WeatherViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(vc: speedViewController, to: containerView)
        addChild(vc: tripViewController, to: tripContainerView)
        addChild(vc: weatherViewController, to: weatherContainerView)
    }
}
