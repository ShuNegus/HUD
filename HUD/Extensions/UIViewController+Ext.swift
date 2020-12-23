//
//  UIViewController+Ext.swift
//  HUD
//
//  Created by Konstantin on 02/12/2020.
//  Copyright © 2020 Konstantin Kuznetsov. All rights reserved.
//

import UIKit

extension UIViewController {

  func addChild(vc: UIViewController, to containerView: UIView) {
    addChild(vc)
    vc.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    vc.view.frame = containerView.bounds
    containerView.addSubview(vc.view)
    vc.didMove(toParent: self)
  }
}
