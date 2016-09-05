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

    // MARK: - Initializer
    convenience init(imageURL: String?, width: NSNumber?, height: NSNumber?, flickrId:String, title:String?, owner:String?, secret:String?, farm:NSNumber?, location:Location, context: NSManagedObjectContext){
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
            // Setting Reference to Location in Image's object
            self.location = location
        }
        else{
            fatalError("Unable to find entity \(CoreDataStack.EntityName.Image)")
        }
    }
    
    // MARK: - Class Methods for Parsing
    class func parseImageJSON(jsonReponse: [[String:AnyObject]], location:Location, context:NSManagedObjectContext) -> [Image]{
        
        // Initializing empty collection of Image objects
        var images = [Image]()
        
        // Iterating and Parsing JSON Response from Flickr and creating Model Objects.
        for currentImageJSON in jsonReponse {
            let imageURL = currentImageJSON[FlickrClient.FlickResponseKeys.ImageURL] as! String
            let width = NSNumber(double: (currentImageJSON[FlickrClient.FlickResponseKeys.ImageWidth] as! NSString).doubleValue)
            let height = NSNumber(double: (currentImageJSON[FlickrClient.FlickResponseKeys.ImageHeight] as! NSString).doubleValue)
            let flickrId = currentImageJSON[FlickrClient.FlickResponseKeys.ImageId] as! String
            let title = currentImageJSON[FlickrClient.FlickResponseKeys.Title] as! String
            let owner = currentImageJSON[FlickrClient.FlickResponseKeys.ImageOwner] as! String
            let secret = currentImageJSON[FlickrClient.FlickResponseKeys.Secret] as! String
            let farm = NSNumber(int: (currentImageJSON[FlickrClient.FlickResponseKeys.ImageWidth] as! NSString).intValue)
            
            // Passing parsed value to Image's initilizer. Also passing Context and Location.
            let currentImage: Image? = Image(imageURL: imageURL, width: width, height: height, flickrId: flickrId, title: title, owner: owner, secret: secret, farm: farm, location: location, context: context)
            if let currentImage = currentImage{
                // If a valid object is created then adding it to collecion of Image Objects
                images.append(currentImage)
            }   
        }
        
        // Returning Image Objects
        return images
    }
}
