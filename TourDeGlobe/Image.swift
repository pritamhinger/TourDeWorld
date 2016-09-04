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
    
    class func parseImageJSON(jsonReponse: [[String:AnyObject]], context:NSManagedObjectContext) -> [Image]{
        var images = [Image]()
        
        for currentImageJSON in jsonReponse {
            let imageURL = currentImageJSON[FlickrClient.FlickResponseKeys.ImageURL] as! String
            //let width = NSNumber(int: currentImageJSON[FlickrClient.FlickResponseKeys.ImageWidth] as! Int32)
            //let height = NSNumber(int: currentImageJSON[FlickrClient.FlickResponseKeys.ImageHeight] as! Int32)
            let width = NSNumber(double: (currentImageJSON[FlickrClient.FlickResponseKeys.ImageWidth] as! NSString).doubleValue)
            let height = NSNumber(double: (currentImageJSON[FlickrClient.FlickResponseKeys.ImageHeight] as! NSString).doubleValue)
            let flickrId = currentImageJSON[FlickrClient.FlickResponseKeys.ImageId] as! String
            let title = currentImageJSON[FlickrClient.FlickResponseKeys.Title] as! String
            let owner = currentImageJSON[FlickrClient.FlickResponseKeys.ImageOwner] as! String
            let secret = currentImageJSON[FlickrClient.FlickResponseKeys.Secret] as! String
            let farm = NSNumber(int: (currentImageJSON[FlickrClient.FlickResponseKeys.ImageWidth] as! NSString).intValue)
            let currentImage: Image? = Image(imageURL: imageURL, width: width, height: height, flickrId: flickrId, title: title, owner: owner, secret: secret, farm: farm, context: context)
            if let currentImage = currentImage{
                images.append(currentImage)
            }   
        }
        
        return images
    }
}
