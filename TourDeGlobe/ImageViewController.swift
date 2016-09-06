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

    // MARK: - Properties
    var location:Location?
    var imageDataSource: [Image]?
    var per_page = 250
    var total = 0
    var page = 1
    
    // MARK: - IBOutlets
    @IBOutlet weak var tappedPinMapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var refreshPhotoAlbumButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting Collection view dimensions.
        // The below procedure handles the resizing of UICollection View Cell on change of Orientation
        reCalculateDimension(true)
        
        // Setting UI as per the Location Passed from Map View
        if let location = location{
            // Setting the pin on read only MapView in ImageVC. This is to depict the location passed on by
            // Map View.
            // Also setting properties of MapView to make it read only by disabling Zoom and Scroll
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
            
            // If location have images collection stored in it, then we would be using saved images and 
            // won't make Network Call
            if let images = location.images{
                // If location.images is not nil
                if images.count > 0{
                    // If location have one or more images
                    imageDataSource = images.allObjects as? [Image]
                }
                else{
                    // If location.images count is zero then try to fetch images from Flickr Server
                    fetchImagesFromFlickerForLocation(location)
                }
            }
            else{
                // location.images is nil, that means this is the first time user navigated for this location
                fetchImagesFromFlickerForLocation(location)
            }
            
        }
        
        self.navigationItem.title = "Flickr Images"
        self.navigationController?.navigationBar.backItem?.title = "Ok"
        collectionView.allowsMultipleSelection = true
    }
    
    // MARK: - IBActions
    @IBAction func refreshPhotoAlbum(sender: UIBarButtonItem) {
        // This procedure is called when the bar button below collection view is clicked.
        // The bar button can have two states.
        // In first state, it will clear all images and initiates a new network call to Flickr Servers to get new images. In this state not a single image is selected
        // In second state, when user select one or more images, then this event would delete only those images
        
        // Getting IndexPath collection of all selected images.
        // We would be using this to decide on the state of the bar button
        let selectedImagesIndexPaths = collectionView.indexPathsForSelectedItems()
        
        // Getting collection of all the Images this particular location have
        // Loction.images is of type NSSet. Below we are getting an array out of NSSet
        var images = location?.images?.allObjects
        
        // Getting reference to Core Data Stack
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        
        if selectedImagesIndexPaths?.count > 0{
            // This block will get executed when user selected one or more images to delete
            
            // Iterating over all NSIndexPaths of selected cells
            for indexPath in selectedImagesIndexPaths!{
                // Getting Collection View Cell using Index Path
                let cell = collectionView.cellForItemAtIndexPath(indexPath)
                
                // Setting Cell selected propperty to false and setting its alpha to 1.0
                cell?.selected = false
                cell?.alpha = 1.0
                
                // Getting referece to image contained by this cell.
                let image = images![indexPath.row] as! Image
                
                // Deleting image from CoreData Context object
                coreDataStack.context.deleteObject(image)
            }
            
            // At this point we have deleted the images from Core Data Context
            // But the image Data Source which is powering our collection view still hold a referecne to image 
            // objects. Beow us the code to update ImageDataSource. We would be removing images from 
            // ImageDataSource as well so that user gets to view an updated collection view
            
            // Sorting SelectedImagesIndexPaths.
            /*************************************
                        Very Very Important
            *************************************/
            // Important:- I have noticed that selectedImageIndexPath which contains NSIndexPaths is not sorted and 
            // may contain index path in any order. Now if we are deleting last 3 or 4 cells, and if we encounter 
            // an index path of lower order (with smaller row value) and delete object from datasource at that 
            // indexpath, then we would end up shortening our data source with one object. Thus the length of data
            // source is now shorter than one of the NSIndexPath which would definetly through 
            // ArrayIndexOutOfBounds
            let sortedIndices = selectedImagesIndexPaths?.sort({ ($0.row > $1.row)})
            
            // Iterating over sorted indiced and deleting one image in each iteration from images
            for index in sortedIndices! {
                images?.removeAtIndex(index.row)
            }
            
            // Setting ImageDataSource to images collection which is left after deleting selected images
            imageDataSource = images as? [Image]
            
            // Saving changes to Context
            coreDataStack.save()
            
            if imageDataSource?.count > 0 {
                // If ImageDataSource still have images then we simply reload the Collection View
                collectionView.reloadData()
            }
            else{
                // Or else we make a netwotk call to Flickr Servers using Flickr APIs
                let randomPage = generateRandomPage()
                fetchImagesFromFlickerForLocation(location!, page: randomPage)
            }
            
        }
        else{
            // This block getsn executed when complete album is to be deleted
            
            // Iterating and deleting all images in images property
            for image in images!{
                coreDataStack.context.deleteObject(image as! Image)
            }
            
            // clear all objects from images as well
            images?.removeAll()
            
            // set image data source to null
            imageDataSource = nil
            
            // save changes to context
            coreDataStack.save()
            
            // make a netwotk call to Flickr Servers using Flickr APIs
            let randomPage = generateRandomPage()
            fetchImagesFromFlickerForLocation(location!, page: randomPage)
        }
        
        // Setting title as per the photos selected in Collection View
        setRefreshPhotoAlbumButtonTitle()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Adding notification for change of orientation of device. We would be re-calculating dimentions of cells.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ImageViewController.screenRotated(_:)), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Removing notification for change of orientation of device as view is not visible
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
}
