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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.alpha = 0.25
        setRefreshPhotoAlbumButtonTitle()
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.alpha = 1.0
        setRefreshPhotoAlbumButtonTitle()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AppConstants.CellIdentifier.FlickrImageViewCell , forIndexPath: indexPath) as! FlickrImageCollectionViewCell
        
        cell.flickrImageView.image = nil
        cell.flickrImageView.image = UIImage(named: "placeholder")
        
        
        let image = imageDataSource?[indexPath.row]
        
        if image?.imageData == nil{
            let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityIndicatorView.center = CGPointMake(cell.contentView.frame.size.width/2, cell.contentView.frame.size.height/2)
            activityIndicatorView.tag = 4
            
            cell.contentView.addSubview(activityIndicatorView)
            performUIUpdatesOnMainQueue{
                activityIndicatorView.startAnimating()
            }
            
            FlickrClient.sharedInstance().getImageDataFromURL((image?.imageURL)!){ (data, error) in
                performUIUpdatesOnMainQueue{
                    activityIndicatorView.stopAnimating()
                    if error == nil{
                        cell.flickrImageView.image = UIImage(data: data!)
                        image?.imageData = data
                    }
                }
            }
        }
        else{
            cell.flickrImageView.image = UIImage(data: (image?.imageData)!)
        }
        
        return cell
    }
}

extension ImageViewController{
    func fetchImagesFromFlickerForLocation(location:Location, page:Int = 1) {
        var queryParameters = [String:String]()
        queryParameters = FlickrClient.addQueryParametersFromPreference(queryParameters)
        queryParameters[FlickrClient.QueryParameterKeys.Latitude] = "\(location.latitude!)"
        queryParameters[FlickrClient.QueryParameterKeys.Longitude] = "\(location.longitude!)"
        queryParameters[FlickrClient.QueryParameterKeys.Page] = "\(page)"
        FlickrClient.sharedInstance().getPhotos(FlickrClient.APIMethod.PhotosSearch, parameters: queryParameters){ (results, error) in
            if error == nil{
                if let results = results{
                    if let photosJSON = results[FlickrClient.FlickResponseKeys.Photos] as? [String:AnyObject]{
                        if let totalImages = photosJSON[FlickrClient.FlickResponseKeys.TotalCount] as? String{
                            self.total = Int(totalImages)!
                        }
                        else{
                            self.total = 0
                        }
                        
                        if let photoJSONArray = photosJSON[FlickrClient.FlickResponseKeys.Photo] as? [[String:AnyObject]]{
                            let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
                            coreDataStack.performBackgroundBatchOperation({(workerContext) in
                                Image.parseImageJSON(photoJSONArray, location: location, context: workerContext.parentContext!){ (images) in
                                    performUIUpdatesOnMainQueue{
                                        location.images = NSSet(array: images)
                                        self.imageDataSource = images
                                        self.collectionView.reloadData()
                                    }
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
        var width = view.frame.size.width
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            width = collectionView.frame.size.width
        }
        else if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            width = view.frame.size.width
        }
        
        let itemSpace = CGFloat(3.0)
        let dimension = (width - (2 * itemSpace))/CGFloat(3.0)
        flowLayout.minimumInteritemSpacing = itemSpace
        flowLayout.minimumLineSpacing = itemSpace
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        if isLoad{
            flowLayout.invalidateLayout()
        }
    }
    
    func setRefreshPhotoAlbumButtonTitle() {
        if(collectionView.indexPathsForSelectedItems()?.count > 0){
            refreshPhotoAlbumButton.title = AppConstants.BarButtonTitle.RemoveSelectedImage
        }
        else{
            refreshPhotoAlbumButton.title = AppConstants.BarButtonTitle.NewCollection
        }
    }
    
    func generateRandomPage() -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        var page = 1
        
        // This is the root cause of bug where same set of images were returned from Flickr.
        // Currently Flickr documentation states that we can only access 4000 images from 
        // Flickr. So if we choose a page and perPage value such that the combination crosses 4000 image,
        // then flickr will reply with same set of images everytime. To fix this we have to make sure the 
        // random page number which we generate along with perpage value results in a value less that 4000.
        // To achieve this we are checking if total count for this LatLong is more than 4000. If so, then we set 
        // total to 4000 so as when we divide total with perPage to get page nevers crossses the threshold.
        if(total > 4000){
            total = 4000
        }
        
        if let perPageCount = userDefaults.valueForKey(FlickrClient.QueryParameterKeys.PerPage) as? Int{
            page = total/perPageCount + 1
        }
        else{
            page = total/FlickrClient.Default.PerPage + 1
            userDefaults.setInteger(FlickrClient.Default.PerPage, forKey: FlickrClient.QueryParameterKeys.PerPage)
        }
        
        if page == 0{
            return 1
        }
        
        let randomPage = Int(arc4random_uniform(UInt32(page))) + 1
        return randomPage
    }
}