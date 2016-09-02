//
//  Image.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 30/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation
import CoreData


class Image: NSManagedObject {

    convenience init(imageURL: String?, width: NSNumber?, height: NSNumber?, flickrId:String, title:String?, owner:String?, secret:String?, farm:NSNumber?, context: NSManagedObjectContext){
        if let entity = NSEntityDescription.entityForName(CoreDataStack.EntityName.Image, inManagedObjectContext: context){
            self.init(entity: entity, insertIntoManagedObjectContext: context)
            self.farm = farm
            self.flickrId = flickrId
            self.height = height
            self.imageURL = imageURL
            self.owner = owner
            self.secret = secret
            self.title = title
            self.width = width
        }
        else{
            fatalError("Unable to find entity \(CoreDataStack.EntityName.Image)")
        }
    }
}
