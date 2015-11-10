//
//  STDataParser.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-09-16.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation
import SwiftyJSON

class STDataParser : NSObject {
    
    class func parseLoginResponse(data: JSON) -> Void {
        AppData.sharedInstance.user = STUser(dictionary: data.dictionaryObject)
        AppData.sharedInstance.loggedIn = true
    }
    
    class func parseDataResponse(data: JSON) -> Void {
        self.parsePhotos(data)
        self.parseStores(data)
    }
    
    class func parsePhotos(data: JSON) -> Void {
        let photosJSON = data["photos"].array
        var photosArray = [STPhoto]()
        
        for photoJSON in photosJSON! as [JSON] {
            let photo: STPhoto = STPhoto(dictionary: photoJSON.dictionaryObject)
            if (photo.is_deleted == "0"){
                photosArray.append(photo)
            }
        }
        AppData.sharedInstance.photos = photosArray
    }

    class func parseStores(data: JSON) -> Void {
        let storesJSON = data["stores"].array
        var storesArray = [STStore]()
        var topStoresArray = [STStore]()
        
        for storeJSON in storesJSON! as [JSON] {
            let store: STStore = STStore(dictionary: storeJSON.dictionaryObject)
            if (store.is_deleted == "0") {
                storesArray.append(STStore(dictionary: storeJSON.dictionaryObject))
                
                if (store.featured == "1") {
                    topStoresArray.append(store)
                }
            }
            
        }
        storesArray.sortInPlace({ $0.store_name < $1.store_name })
        topStoresArray.sortInPlace({ $0.store_name < $1.store_name })
        
        AppData.sharedInstance.stores = storesArray
        AppData.sharedInstance.topStores = topStoresArray
    }

    class func parseCategoriesResponse(data: JSON) -> Void {
        let categoriesJSON = data["categories"].array!
        var categoriesArray = [STCategory]()
        var topCategoriesArray = [STCategory]()
        
        for categoryJSON in categoriesJSON {
            let category: STCategory = STCategory(dictionary: categoryJSON.dictionaryObject)
            categoriesArray.append(category)
            
            if (category.feat == "1") {
                topCategoriesArray.append(category)
            }
        }
        categoriesArray.sortInPlace({ $0.category < $1.category })
        topCategoriesArray.sortInPlace({ $0.category < $1.category })
        
        AppData.sharedInstance.categories = categoriesArray
        AppData.sharedInstance.topCategories = topCategoriesArray
    }
    
    
    class func parseWeatherResponse(data: JSON) -> Void {
        let weather = data["main"]["temp"].floatValue
        AppData.sharedInstance.weather = Float.fromKelvinToCelsius(weather)
    }
}