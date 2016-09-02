//
//  Location.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 30/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation
import CoreData


class Location: NSManagedObject {
    
    convenience init(latitude:Double, longitude:Double, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName(CoreDataStack.EntityName.Location, inManagedObjectContext: context){
            self.init(entity: entity, insertIntoManagedObjectContext: context)
            self.latitude = NSNumber(double: latitude)
            self.longitude = NSNumber(double: longitude)
            self.creationDate = NSDate()
        }
        else{
            fatalError("Unable to find entity \(CoreDataStack.EntityName.Location)")
        }
    }
}
