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

    var modalAdsViewController: ModalAdsViewController!
    
    // MARK: UIViewcontroller Life cycle

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(STBaseViewController.showModalAddViewController), name:kDisplayModalAddNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(STBaseViewController.hideModalAddViewController), name:kHideModalAddNotification, object: nil)

        if (self.isKindOfClass(MapViewController)) {
            self.setMapsNavigationController()
        }
        else {
            if (self.isKindOfClass(LoginViewController)) {
                self.setDefaultNavigationController(false, transparent: true, withSearch: false)
            }
            else {
                if (self.isKindOfClass(ProfileViewController)) {
                    self.setProfileNavigationController()
                }
                else {
                    if (self.isKindOfClass(SearchViewController)) {
                        self.setSearchNavigationController()
                    }
                    else {
                        self.setDefaultNavigationController(true, transparent: false, withSearch: true)
                    }
                }
            }
        }
    }

    func showModalAddViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.modalAdsViewController = storyboard.instantiateViewControllerWithIdentifier("ModalAdsViewController") as? ModalAdsViewController

        if let modalAdsViewController = self.modalAdsViewController {
            modalAdsViewController.modalPresentationStyle = .OverFullScreen
            self.presentViewController(modalAdsViewController, animated: true, completion: nil)
        }
    }

    func hideModalAddViewController () {
        self.modalAdsViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
