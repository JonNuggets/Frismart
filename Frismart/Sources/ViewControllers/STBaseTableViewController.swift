//
//  STBaseTableViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-09-10.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class STBaseTableViewController: UITableViewController {
    
    // MARK: UIViewcontroller Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Appeler les fonctions dans l'extension
        
        if (self.isKindOfClass(StoresPerCategoryViewController) || self.isKindOfClass(StoreDetailsViewController)) {
            self.setNavigationControllerWithBack(true)
        }
        else {
            self.setDefaultNavigationController(true, transparent: false)
        }
    }
}
