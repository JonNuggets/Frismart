//
//  STCategory.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-09-24.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class STCategory: STBaseModel {
    var category_id: String?
    var category_name: String?
    var category_desc: String?
    var feat: String?
    var keywords: String?
    var category_icon: String?
    var created_at: String?
    var updated_at: String?
    var is_deleted: String?
    var og_img: String?
    var desc: String?
    
    func getStoresPerCategory()->[STStore]{
        var stores = [STStore]()
        
        for store in AppData.sharedInstance.stores! {
            if self.category_id == store.category_id {
                stores.append(store)
            }
        }
        return stores
    }
}