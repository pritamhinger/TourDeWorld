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
        
        cell.flickrImageView.image = UIImage(named: "placeholder")
        
        if image?.imageData == nil{
            let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityIndicatorView.center = CGPointMake(cell.contentView.frame.size.width/2, cell.contentView.frame.size.height/2)
            cell.contentView.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
            
            FlickrClient.sharedInstance().getImageDataFromURL((image?.imageURL)!){ (data, error) in
                performUIUpdatesOnMainQueue{
                    if error == nil{
                        cell.flickrImageView.image = UIImage(data: data!)
                        image?.imageData = data
                    }
                    
                    activityIndicatorView.stopAnimating()
                }
            }
        }
        else{
            print("Didn't made network request")
            cell.flickrImageView.image = UIImage(data: (image?.imageData)!)
        }
        
        print("Cell width : \(cell.frame.size.width)")
        print("cell height : \(cell.frame.size.height)")
        
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
                if let results = results{
                    if let photosJSON = results[FlickrClient.FlickResponseKeys.Photos] as? [String:AnyObject]{
                        
                        if let photoJSONArray = photosJSON[FlickrClient.FlickResponseKeys.Photo] as? [[String:AnyObject]]{
                            let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
                            coreDataStack.performBackgroundBatchOperation({(workerContext) in
                                let images = Image.parseImageJSON(photoJSONArray, location: location, context: workerContext.parentContext!)
                                location.images = NSSet(array: images)
                                performUIUpdatesOnMainQueue{
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

extension ImageViewController{
    func screenRotated(notification:NSNotification) {
        reCalculateDimension(false)
    }
    
    func reCalculateDimension(isLoad:Bool) {
        if isLoad {
            print("Called from View Did Load")
        }
        
        var factor = 3.0
        var width = view.frame.size.width
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            print("landscape")
            factor = 3.0
            width = collectionView.frame.size.width
        }
        else if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            print("Portrait")
            factor = 3.0
            width = view.frame.size.width
        }
        
        let itemSpace = CGFloat(factor)
        let dimension = (width - (2 * itemSpace))/CGFloat(factor)
        flowLayout.minimumInteritemSpacing = itemSpace
        flowLayout.minimumLineSpacing = itemSpace
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        if isLoad{
            print("Factor \(factor)")
            print("itemSpace \(itemSpace)")
            print("Dimension \(dimension)")
            print("width \(collectionView.frame.size.width)")
            print("height \(collectionView.frame.size.height)")
            flowLayout.invalidateLayout()
        }
    }
}