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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(STBaseViewController.showModalAddViewController), name:kDisplayModalAddNotification, object: nil)

        // Appeler les fonctions dans l'extension
        
        if (self.isKindOfClass(StoresPerCategoryViewController) || self.isKindOfClass(StoreDetailsViewController)) {
            self.setNavigationControllerWithBack(true)
        }
        else {
            self.setDefaultNavigationController(true, transparent: false, withSearch: true)
        }
    }

    func showModalAddViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modalAdsViewController: ModalAdsViewController!
        modalAdsViewController = storyboard.instantiateViewControllerWithIdentifier("ModalAdsViewController") as? ModalAdsViewController

        if let modalAdsViewController = modalAdsViewController {
            modalAdsViewController.modalPresentationStyle = .OverFullScreen
            self.presentViewController(modalAdsViewController, animated: true, completion: nil)
        }
    }
}
