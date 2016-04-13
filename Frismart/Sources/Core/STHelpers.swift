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

        for favoriteItem in AppData.sharedInstance.favoriteStores {
            if favoriteItem.store_id == currentStore.store_id {
                favoriteButton.setImage(UIImage(named: "StoreDetails_Like_Checked")!.imageWithColor(UIColor.redColor()), forState: .Normal)
                favoriteButton.selected = true
                favoriteFound = true
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
            let storeLocation: CLLocation = CLLocation(latitude: store.lat.doubleValue, longitude: store.lon.doubleValue)
            newDistance = (AppData.sharedInstance.user?.currentLocation?.distanceFromLocation(storeLocation))!
            
            if newDistance < distance {
                distance = newDistance
                nearestStore = store
            }
        }
        
        return nearestStore
    }
    
    class func sortByDistance(stores: [STStore])->[STStore]{
        var distancesFromLocation = [String:Double]()
        
        if AppData.sharedInstance.loggedIn == true {
            
            for store in stores {
                let storeLocation: CLLocation = CLLocation(latitude: store.lat.doubleValue, longitude: store.lon.doubleValue)
                let distanceFromLocation = AppData.sharedInstance.user?.currentLocation?.distanceFromLocation(storeLocation)
                distancesFromLocation[store.store_id] = distanceFromLocation
            }
        }

        print(distancesFromLocation)
        
        return [STStore]()
    }
    
    class func getWeekDay(weekDay: String)->Int {
        switch weekDay.lowercaseString {
            case "lun": return 1
            case "mar": return 2
            case "mer": return 3
            case "jeu": return 4
            case "ven": return 5
            case "sam": return 6
            case "dim": return 7
            default: return -1
        }
    }

    class func searchStoresByKeyWord(text: String)->[STStore] {
        var stores = [STStore]()
        
        for category in AppData.sharedInstance.categories! {
            if category.category_name.lowercaseString.rangeOfString(text.lowercaseString) != nil {
                stores.appendContentsOf(category.getStoresPerCategory())
            }
        }
        
        for store in AppData.sharedInstance.stores! {
            if store.store_name.lowercaseString.rangeOfString(text.lowercaseString) != nil {
                if !stores.contains(store) {
                    stores.append(store)
                }
            }
        }
        
        STHelpers.sortByDistance(stores)

        return stores
    }

    // MARK:- JSON helpers

    // Helper function to Generate JSON string from Dictionary -> [String : AnyObject]! SwiftyJSON
    class func nsobjectToJSON(dicObject: [String : AnyObject]!) {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dicObject, options: NSJSONWritingOptions.PrettyPrinted)
            let strJSON : NSString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)!

            print("\(strJSON)")

        } catch let error as NSError {
            print(error)
        }
    }
}