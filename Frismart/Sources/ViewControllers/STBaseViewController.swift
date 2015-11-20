//
//  STBaseViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-19.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation
import iAd

class STBaseViewController: UIViewController {
    
    // MARK: UIViewcontroller Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (self.isKindOfClass(MapViewController)) {
            self.setMapsNavigationController()
        }
        else {
            if (self.isKindOfClass(LoginViewController)) {
                self.setDefaultNavigationController(true, transparent: true)
            }
            else {
                self.setDefaultNavigationController(true, transparent: false)
            }
        }
    }
}
