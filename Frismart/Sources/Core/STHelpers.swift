//
//  STHelpers.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-09-16.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation
import CoreLocation

class STHelpers: NSObject {

    class func setCurrentLocation(currentLocation: CLLocation) {
        
    }
    
    class func initializeLocationManager(locationManager: CLLocationManager) -> Void {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    class func updateFavoriteIconInfo(currentStore: STStore, favoriteButton: UIButton) -> UIButton {
        
        var favoriteFound = false
        
        favoriteButton.setImage(UIImage(named: "StoreDetails_Like_Checked")!.imageWithColor(UIColor.redColor()), forState: .Normal)
        
        favoriteButton.enabled = true
        favoriteButton.selected = false
        favoriteButton.highlighted = false
        
        for (var index = 0; index < AppData.sharedInstance.favoriteStores.count; index++) {
            if let favoriteItem:STStore = AppData.sharedInstance.favoriteStores[index] {
                if favoriteItem.store_id == currentStore.store_id {
                    favoriteButton.setImage(UIImage(named: "StoreDetails_Like_Checked")!.imageWithColor(UIColor.redColor()), forState: .Normal)
                    favoriteButton.selected = true
                    favoriteFound = true
                }
            }
        }
        
        if favoriteFound == false {
            favoriteButton.setImage(UIImage(named: "StoreDetails_Like_Unchecked")!.imageWithColor(UIColor.redColor()), forState: .Normal)
        }
        return favoriteButton
    }
}