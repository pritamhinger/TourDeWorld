//
//  Image+CoreDataProperties.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 30/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Image {

    @NSManaged var imageURL: String?
    @NSManaged var width: NSNumber?
    @NSManaged var height: NSNumber?
    @NSManaged var flickrId: String?
    @NSManaged var title: String?
    @NSManaged var owner: String?
    @NSManaged var secret: String?
    @NSManaged var farm: NSNumber?
    @NSManaged var location: Location?

}
