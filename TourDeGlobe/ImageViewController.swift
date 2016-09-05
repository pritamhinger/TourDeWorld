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
                    //collectionView.reloadData()
                }
                else{
                    fetchImagesFromFlickerForLocation(location)
                }
            }
            else{
                fetchImagesFromFlickerForLocation(location)
            }
            
            self.navigationItem.title = "Flickr Images"
        }
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
