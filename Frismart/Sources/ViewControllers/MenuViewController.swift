//
//  MenuViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-19.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

enum STMenuScreen : Int {
    case MenuScreen_Login           = 0
    case MenuScreen_Home            = 1
    case MenuScreen_Categories      = 2
    case MenuScreen_Maps            = 3
    case MenuScreen_Favorites       = 4
    
    static var count: Int {
        return STMenuScreen.MenuScreen_Favorites.rawValue+1
    }
}

let stMenuList                  : Array     = ["Menu_Login", "Menu_Home", "Menu_Categories", "Menu_Maps",
                                               "Menu_Favorites", "Menu_Settings", "Menu_Logout"]
let kLoggedHeightForRow         : CGFloat   = 150.0
let kDefaultHeightForRow        : CGFloat   = 60.0
let kZeroHeightForRow           : CGFloat   = 0.0

class MenuViewController : UITableViewController, CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.locationManager.delegate = self
        STHelpers.initializeLocationManager(self.locationManager)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager.stopUpdatingLocation()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return STMenuScreen.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == STMenuScreen.MenuScreen_Login.rawValue) {
            if (AppData.sharedInstance.loggedIn) {
                return kLoggedHeightForRow
            }
        }
    
        return kDefaultHeightForRow
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row == STMenuScreen.MenuScreen_Login.rawValue) {
            if (AppData.sharedInstance.loggedIn) {
                let infosMenuCell: InfosMenuCell = tableView.dequeueReusableCellWithIdentifier(kInfosMenuTableViewCellIdentifier) as! InfosMenuCell
                return infosMenuCell
            }
        }
        
        let menuCell: MenuCell = tableView.dequeueReusableCellWithIdentifier(kMenuTableViewCellIdentifier) as! MenuCell
        return menuCell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row == STMenuScreen.MenuScreen_Login.rawValue) {
            if (AppData.sharedInstance.loggedIn) {
                let infosMenuCell: InfosMenuCell = cell as! InfosMenuCell
                infosMenuCell.prepareForReuse()
                self.locationManager.startUpdatingLocation()
                infosMenuCell.display()
            }
            else {
                let menuCell : MenuCell = cell as! MenuCell
            
                menuCell.menuLabel.text = NSLocalizedString(stMenuList[indexPath.row], comment:"").uppercaseString
                menuCell.menuIconImageView.image = UIImage(named: (stMenuList[indexPath.row] as String) + "Icon")?.imageWithColor(UIColor().frismartTableViewBackgroundColor)
            }
        }
        else {
            let menuCell : MenuCell = cell as! MenuCell
            menuCell.menuLabel.text = NSLocalizedString(stMenuList[indexPath.row], comment:"").uppercaseString
            menuCell.menuIconImageView.image = UIImage(named: (stMenuList[indexPath.row] as String) + "Icon")?.imageWithColor(UIColor().frismartTableViewBackgroundColor)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row == STMenuScreen.MenuScreen_Login.rawValue) {
            if (!AppData.sharedInstance.loggedIn) {
                
                let loginNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginNavigationController") as? UINavigationController
                self.revealViewController().pushFrontViewController(loginNavigationController, animated: true)
            }
            else {
                let profileNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileNavigationController") as? UINavigationController
                self.revealViewController().pushFrontViewController(profileNavigationController, animated: true)
            }
        }

        if (indexPath.row == STMenuScreen.MenuScreen_Home.rawValue) {
            let homeNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeNavigationController") as? UINavigationController
            self.revealViewController().pushFrontViewController(homeNavigationController, animated: true)
        }
        
        if (indexPath.row == STMenuScreen.MenuScreen_Categories.rawValue) {
            let categoriesNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("CategoriesNavigationController") as? UINavigationController
            self.revealViewController().pushFrontViewController(categoriesNavigationController, animated: true)
        }
        
        if (indexPath.row == STMenuScreen.MenuScreen_Maps.rawValue) {
            let mapsNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("MapsNavigationController") as? UINavigationController
            self.revealViewController().pushFrontViewController(mapsNavigationController, animated: true)
        }
        
        if (indexPath.row == STMenuScreen.MenuScreen_Favorites.rawValue) {
            let favoritesNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("FavoritesNavigationController") as? UINavigationController
            self.revealViewController().pushFrontViewController(favoritesNavigationController, animated: true)
        }
    }
    
    //MARK : CoreLocation Delegate Methods
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if (AppData.sharedInstance.loggedIn) {
            if let _ : CLLocation = newLocation {
                self.currentLocation = newLocation
                self.getPlacemark()
            }
        }
    }
    
    private func getPlacemark() -> Void {
        let geoCoder = CLGeocoder()
        
        AppData.sharedInstance.user?.currentLocation = self.currentLocation
        
        geoCoder.reverseGeocodeLocation(self.currentLocation!, completionHandler: { (placeMarksArray, error) -> Void in
            if error == nil && placeMarksArray!.count > 0 {
                AppData.sharedInstance.user?.currentPlacemark = placeMarksArray![placeMarksArray!.endIndex - 1]
                STConnectionManager.getWeather((AppData.sharedInstance.user?.currentPlacemark)!, onSuccessHandler: self.onWeatherSuccess, onFailureHandler: nil)
            }
        })
    }
    
    func onWeatherSuccess(data: JSON) -> Void {
        STDataParser.parseWeatherResponse(data)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
}