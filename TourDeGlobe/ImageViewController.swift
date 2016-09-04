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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            fetchImagesFromFlickerForLocation(location)
        }
    }
}
