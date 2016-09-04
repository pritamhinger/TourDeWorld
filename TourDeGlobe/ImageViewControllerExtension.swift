//
//  ImageViewControllerExtension.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 04/09/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let imageDataSource = imageDataSource{
            return imageDataSource.count
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AppConstants.CellIdentifier.FlickrImageViewCell , forIndexPath: indexPath) as! FlickrImageCollectionViewCell
        
        let image = imageDataSource?[indexPath.row]
        print("Image URL is : \(image?.imageURL)")
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicatorView.center = CGPointMake(cell.contentView.frame.size.width/2, cell.contentView.frame.size.height/2)
        cell.contentView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        FlickrClient.sharedInstance().getImageFromURL((image?.imageURL)!){ (image, error) in
            performUIUpdatesOnMainQueue{
                if error == nil{
                    cell.flickrImageView.image = image
                }
                
                activityIndicatorView.stopAnimating()
            }
        }
        
        return cell
    }
}

extension ImageViewController{
    func fetchImagesFromFlickerForLocation(location:Location) {
        var queryParameters = [String:String]()
        queryParameters = FlickrClient.addQueryParametersFromPreference(queryParameters)
        queryParameters[FlickrClient.QueryParameterKeys.Latitude] = "\(location.latitude!)"
        queryParameters[FlickrClient.QueryParameterKeys.Longitude] = "\(location.longitude!)"
        FlickrClient.sharedInstance().getPhotos(FlickrClient.APIMethod.PhotosSearch, parameters: queryParameters){ (results, error) in
            if error == nil{
                print(results)
                
                if let results = results{
                    if let photosJSON = results[FlickrClient.FlickResponseKeys.Photos] as? [String:AnyObject]{
                        
                        if let photoJSONArray = photosJSON[FlickrClient.FlickResponseKeys.Photo] as? [[String:AnyObject]]{
                            let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
                            coreDataStack.performBackgroundBatchOperation({(workerContext) in
                                let images = Image.parseImageJSON(photoJSONArray, context: workerContext)
                                print("Image Count is \(images.count)")
                                performUIUpdatesOnMainQueue{
                                    print("Reloading colleciton view")
                                    self.imageDataSource = images
                                    self.collectionView.reloadData()
                                }
                            })
                        }
                    }
                }
                
            }
            else{
                print(error)
            }
        }
    }
}