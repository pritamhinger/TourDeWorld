//
//  ViewController.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 28/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureReconizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.tap(_:)))
        view.addGestureRecognizer(tapGestureReconizer)
    }
    
    
    @IBAction func testButton(sender: AnyObject) {
        var queryParameters = [String:String]()
        queryParameters = FlickrClient.addQueryParametersFromPreference(queryParameters)
        queryParameters[FlickrClient.QueryParameterKeys.Latitude] = "\(25.92)"
        queryParameters[FlickrClient.QueryParameterKeys.Longitude] = "\(74.26)"
        FlickrClient.sharedInstance().getPhotos(FlickrClient.APIMethod.PhotosSearch, parameters: queryParameters){ (results, error) in
            if error == nil{
                print(results)
            }
            else{
                print(error)
            }
        }
    }
    
    // MARK: - Tap Gesture Handlers
    func tap(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.Ended{
            return
        }
        
        let touchedLocation = sender.locationInView(mapView)
        let locationCoordinate = mapView.convertPoint(touchedLocation, toCoordinateFromView: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        mapView.addAnnotation(annotation)
    }
}

