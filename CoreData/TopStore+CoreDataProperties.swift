//
//  TopStore+CoreDataProperties.swift
//  
//
//  Created by James Laurenstin on 2016-04-14.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TopStore {

    @NSManaged var category_id: String?
    @NSManaged var created_at: String?
    @NSManaged var distance: String?
    @NSManaged var email: String?
    @NSManaged var featured: String?
    @NSManaged var horaire: String?
    @NSManaged var icon_id: String?
    @NSManaged var is_deleted: String?
    @NSManaged var lat: String?
    @NSManaged var lon: String?
    @NSManaged var phone_no: String?
    @NSManaged var rating_count: String?
    @NSManaged var rating_total: String?
    @NSManaged var sms_no: String?
    @NSManaged var store_address: String?
    @NSManaged var store_desc: String?
    @NSManaged var store_id: String?
    @NSManaged var store_name: String?
    @NSManaged var updated_at: String?
    @NSManaged var website: String?

}
