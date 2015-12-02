//
//  AppData.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-19.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation
import SwiftyJSON

let kMenuTableViewCellIdentifier            :String = "defaultMenuCell"
let kInfosMenuTableViewCellIdentifier       :String = "infosUserMenuCell"
let kCategoryTableViewCellIdentifier        :String = "categoryCell"

let kStoreDetailsTableViewCellIdentifier    :String = "storeDetailsInfoCell"
let kStoreDescTableViewCellIdentifier       :String = "storeDescCell"
let kStoreMapTableViewCellIdentifier        :String = "storeMapCell"
let kStoreContactTableViewCellIdentifier    :String = "storeContactCell"
let kStoreImagesTableViewCellIdentifier     :String = "storeImagesCell"
let kStoreRateTableViewCellIdentifier       :String = "storeRateCell"
let kStoreFullDescTableViewCellIdentifier   :String = "storeFullDescCell"

let kStoreInfoTableViewCellIdentifier       :String = "storeInfoCell"

let kGetStoresPerCategorySegue              :String = "getStoresPerCategorySegue"
let kGetStoreDetailsSegue                   :String = "getStoreDetailsSegue"
let kShowStoresForTopCategorySegue          :String = "showStoresForTopCategorySegue"
let kShowTopStoreDetailsSegue               :String = "showTopStoreDetailsSegue"
let kShowFavoriteStoreSegue                 :String = "showFavoriteStoreSegue"
let kFlipToProfileSegue                     :String = "flipToProfileSegue"

let kTopCategoryViewNibName                 :String = "TopCategoryView"
let kTopStoreViewNibName                    :String = "TopStoreView"
let kStoreDetailsThumbNibName               :String = "StoreDetailsThumbView"
let kCategoryIconViewNibName                :String = "CategoryIconView"

// Twitter
let kTWITTER_CONSUMER_KEY               :String = "SKEcWg9QJdpOGjxfPEUrOfrI0"
let kTWITTER_CONSUMER_SECRET            :String = "Hf1ems23OtoK52rcHbVW46s8oTmoP3t56cQZkw1YhjfR1zFjBP"

// Google Maps
let kGOOGLEMAPS_API_KEY                 :String = "AIzaSyDChwhL4PpNedghpiEZlD_k6HQfup_PLc4"

// Frismart Error Code
let kFrismartErrorAPICode               :String = "-1"

class AppData : NSObject {
    
    var loggedIn: Bool = false
    var stores: [STStore]?
    var topStores: [STStore]?
    var favoriteStores: [STStore] = [STStore]()
    var categories: [STCategory]?
    var topCategories: [STCategory]?
    var photos: [STPhoto]?
    var user: STUser?
    var weather: Int?
    var activityIndicatorView: STActivityIndicatorView?

    class var sharedInstance : AppData {
        struct Static {
            static let instance : AppData = AppData()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        
        self.loggedIn = false
        self.stores = [STStore]()
        self.categories = [STCategory]()
        self.topCategories = [STCategory]()
        self.topStores = [STStore]()
        self.photos = [STPhoto]()
        self.user = STUser()
    }
    
    func clearPersonnalData() -> Void {
        self.loggedIn = false
        self.user = STUser()
    }
}