//
//  UIViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-19.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation


let kRevealWithPercentage : CGFloat = 0.85

extension UIViewController {
    
    func setDefaultNavigationController(withIcon: Bool, transparent: Bool)-> Void{
        
        if transparent{
            self.setNavigationControllerTransparent()
        }
        else {
            self.setNavigationControllerFrismartColor()
        }
        
        if withIcon {
            let logoImage = UIImage(named: "LogoIcon")
            let logoImageView = UIImageView(image: logoImage)
            self.navigationItem.titleView = logoImageView
        }
        
        let searchButton  = UIBarButtonItem(image: UIImage(named: "NavBar_Search"), style: UIBarButtonItemStyle.Plain, target: self, action: "revealSearch:")
        self.navigationItem.rightBarButtonItem = searchButton
        
        if self.revealViewController() != nil {
            let menuButton  = UIBarButtonItem(image: UIImage(named: "NavBar_HamburgerMenuButtonImage")?.imageWithColor(UIColor.whiteColor()), style: UIBarButtonItemStyle.Plain, target: self.revealViewController(), action: "revealToggle:")
            self.revealViewController().rearViewRevealWidth = self.view.bounds.width * kRevealWithPercentage
            self.navigationItem.leftBarButtonItems = [menuButton]
        }
    }
    
    func setNavigationControllerWithBack(withIcon: Bool)-> Void{
        
        self.setNavigationControllerFrismartColor()
        
        if withIcon {
            let logoImage = UIImage(named: "LogoIcon")
            let logoImageView = UIImageView(image: logoImage)
            self.navigationItem.titleView = logoImageView
        }
        
        let searchButton  = UIBarButtonItem(image: UIImage(named: "NavBar_Search"), style: UIBarButtonItemStyle.Plain, target: self, action: "revealSearch:")
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    func revealSearch(sender: UIBarButtonItem) {
        print("Go to the Search Screen")
    }
    
    func setNavigationControllerTransparent()->Void{
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
    }
    
    func setNavigationControllerFrismartColor()->Void{
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor().frismartDefaultBackgroundColor
    }
}