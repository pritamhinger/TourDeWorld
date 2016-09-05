//
//  ImageViewController.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 04/09/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit
import MapKit

class ImageViewController: UIViewController {

    var location:Location?
    var imageDataSource: [Image]?
    
    @IBOutlet weak var tappedPinMapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var refreshPhotoAlbumButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reCalculateDimension(true)
        
        if let location = location{
            var region = self.tappedPinMapView.region
            let coordinate = CLLocationCoordinate2DMake(Double(location.latitude!), Double(location.longitude!))
            region.center = coordinate
            region.span.latitudeDelta /= AppConstants.DetailViewMapLatitudeZoomLevel
            region.span.longitudeDelta /= AppConstants.DetailViewMapLongitudeZoomLevel
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            tappedPinMapView.addAnnotation(annotation)
            tappedPinMapView.setRegion(region, animated: true)
            tappedPinMapView.scrollEnabled = false
            tappedPinMapView.zoomEnabled = false
            
            if let images = location.images{
                if images.count > 0{
                    imageDataSource = images.allObjects as? [Image]
                }
                else{
                    fetchImagesFromFlickerForLocation(location)
                }
            }
            else{
                fetchImagesFromFlickerForLocation(location)
            }
            
        }
        
        self.navigationItem.title = "Flickr Images"
        self.navigationController?.navigationBar.backItem?.title = "Ok"
        collectionView.allowsMultipleSelection = true
    }
    
    @IBAction func refreshPhotoAlbum(sender: UIBarButtonItem) {
        let selectedImagesIndexPaths = collectionView.indexPathsForSelectedItems()
        var images = location?.images?.allObjects
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        
        if selectedImagesIndexPaths?.count > 0{
            
            for indexPath in selectedImagesIndexPaths!{
                let cell = collectionView.cellForItemAtIndexPath(indexPath)
                cell?.selected = false
                cell?.alpha = 1.0
                let image = images![indexPath.row] as! Image
                coreDataStack.context.deleteObject(image)
            }
            
            imageDataSource = location?.images?.allObjects as? [Image]
            let sortedIndices = selectedImagesIndexPaths?.sort({ ($0.row > $1.row)})
            for index in sortedIndices! {
                images?.removeAtIndex(index.row)
            }
        }
        else{
            for image in images!{
                coreDataStack.context.deleteObject(image as! Image)
            }
            
            images?.removeAll()
            imageDataSource = nil
        }
        
        if(images?.count == 0){
            self.imageDataSource = nil
        }
        else{
            self.imageDataSource = images as? [Image]
        }
        
        //self.collectionView.reloadData()
        collectionView.reloadData()
        setRefreshPhotoAlbumButtonTitle()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ImageViewController.screenRotated(_:)), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
}
