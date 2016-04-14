//
//  STStore.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-09-15.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation
import CoreLocation

class STStore : STBaseModel {
    var store_id : String = ""
    var icon_id : String = ""
    var category_id : String = ""
    var email : String = ""
    var phone_no : String = ""
    var sms_no : String = ""
    var lon : String = ""
    var lat : String = ""
    var store_desc : String = ""
    var store_address : String = ""
    var store_name : String = ""
    var rating_count : String = ""
    var featured : String = ""
    var updated_at : String = ""
    var created_at : String = ""
    var rating_total : String = ""
    var website : String = ""
    var distance : String = ""
    var is_deleted: String = ""
    var horaire: String = ""
    var geoDistance: CLLocationDistance?
    
    func getPhotos()->[STPhoto]{
        var photoArray = [STPhoto]()
        
        if AppData.sharedInstance.photos.count > 0 {
            for photo in AppData.sharedInstance.photos {
                if photo.store_id == self.store_id {
                    photoArray.append(photo)
                }
            }
        }
        return photoArray
    }
    
    func getCategory()->String{
        for category in AppData.sharedInstance.categories {
            if self.category_id == category.category_id {
                return category.category_name
            }
        }
        return ""
    }
}
