//
//  Location+CoreDataProperties.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 31/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var creationDate: NSDate?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var images: Image?

}
