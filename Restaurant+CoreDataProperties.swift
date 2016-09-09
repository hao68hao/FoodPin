//
//  Restaurant+CoreDataProperties.swift
//  FoodPin
//
//  Created by lauda on 16/7/13.
//  Copyright © 2016年 lauda. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Restaurant {

    @NSManaged var name: String
    @NSManaged var type: String
    @NSManaged var location: String
    @NSManaged var rating: String?
    @NSManaged var isVisited: NSNumber
    @NSManaged var image: NSData?

}
