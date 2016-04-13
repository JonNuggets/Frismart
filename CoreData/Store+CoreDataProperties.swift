//
//  Store+CoreDataProperties.swift
//  
//
//  Created by James Laurenstin on 2016-04-13.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Store {

    @NSManaged var rating_count: String?
    @NSManaged var store_name: String?
    @NSManaged var lon: String?
    @NSManaged var sms_no: String?
    @NSManaged var category_id: String?
    @NSManaged var created_at: String?
    @NSManaged var featured: String?
    @NSManaged var phone_no: String?
    @NSManaged var store_address: String?
    @NSManaged var lat: String?
    @NSManaged var updated_at: String?
    @NSManaged var store_id: String?
    @NSManaged var horaire: String?
    @NSManaged var is_deleted: String?
    @NSManaged var website: String?
    @NSManaged var email: String?
    @NSManaged var rating_total: String?
    @NSManaged var store_desc: String?

}
