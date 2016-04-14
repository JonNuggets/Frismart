//
//  TopCategory+CoreDataProperties.swift
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

extension TopCategory {

    @NSManaged var category_desc: String?
    @NSManaged var category_icon: String?
    @NSManaged var category_id: String?
    @NSManaged var created_at: String?
    @NSManaged var desc: String?
    @NSManaged var feat: String?
    @NSManaged var is_deleted: String?
    @NSManaged var keywords: String?
    @NSManaged var updated_at: String?
    @NSManaged var og_img: String?
    @NSManaged var category_name: String?

}
