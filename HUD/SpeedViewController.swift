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

    // Force unwrap лучше не юзать, это дурной тон. Так же тут константа
    let speedManager = SpeedManager()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speedManager.delegate = self
    }

}

// MARK: - SpeedManagerDelegate

extension SpeedViewController: SpeedManagerDelegate {
    // CLLocationSpeed дает скорость метр в секунду.
    // Лучше специфичные типы фреймворка, дальне менеджера не выпускать
    // В данном случае, лучше заюзать стандартную структуру для различных величин - Measurement
    // Она generic, и может быть скоростью, массой, длинной и тд. в нашем случае берем скорость
    func speedDidChange(speed: Measurement<UnitSpeed>) {
        let kmHMesure = speed.converted(to: .kilometersPerHour)
        speedOutput?.text = String(kmHMesure.value)
        speedUnitsOutput?.text = "KM/H"
        print(speed)
    }
}

