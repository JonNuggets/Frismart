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
    
    class func getNearestStore()->STStore {
    
        var distance: Double = Double(999999)
        var newDistance: Double = Double(0)
        var nearestStore: STStore = STStore()
        
        for store in AppData.sharedInstance.stores! {
            let storeLocation: CLLocation = CLLocation(latitude: (store.lat?.doubleValue)!, longitude: (store.lon?.doubleValue)!)
            newDistance = (AppData.sharedInstance.user?.currentLocation?.distanceFromLocation(storeLocation))!
            
            if newDistance < distance {
                distance = newDistance
                nearestStore = store
            }
        }
        
        return nearestStore
    }
    
    class func getWeekDay(weekDay: String)->Int {
        switch weekDay {
            case "lun": return 0
            case "mar": return 1
            case "mer": return 2
            case "jeu": return 3
            case "ven": return 4
            case "sam": return 5
            case "dim": return 6
            default: return -1
        }
    }
}