//
//  Photo+CoreDataProperties.swift
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

extension Photo {

    @NSManaged var photo_url: String?
    @NSManaged var created_at: String?
    @NSManaged var photo_id: String?
    @NSManaged var thumb_url: String?
    @NSManaged var is_deleted: String?
    @NSManaged var updated_at: String?
    @NSManaged var store_id: String?

}
