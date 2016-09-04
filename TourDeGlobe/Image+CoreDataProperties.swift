//
//  Image+CoreDataProperties.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 04/09/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Image {

    @NSManaged var farm: NSNumber?
    @NSManaged var flickrId: String?
    @NSManaged var height: NSNumber?
    @NSManaged var imageURL: String?
    @NSManaged var owner: String?
    @NSManaged var secret: String?
    @NSManaged var title: String?
    @NSManaged var width: NSNumber?
    @NSManaged var imageData: NSData?
    @NSManaged var location: Location?

}
