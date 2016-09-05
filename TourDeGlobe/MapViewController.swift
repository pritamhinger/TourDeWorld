//
//  ViewController.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 28/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    var annotationMap = [MKPointAnnotation: Location]()
    
    var fetchResultsController: NSFetchedResultsController?{
        didSet{
            fetchResultsController?.delegate = self
            getLocations()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = false
        mapView.zoomEnabled = true
        
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        let fetchRequest = NSFetchRequest(entityName: CoreDataStack.EntityName.Location)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        let tapGestureReconizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.tap(_:)))
        view.addGestureRecognizer(tapGestureReconizer)
        self.navigationController?.title = "Map View"
    }
    
    
    
    @IBAction func editingSwitched(sender: UIBarButtonItem) {
        
        if sender.tag == 1{
            sender.tag = 2
            sender.title = "Done"
            sender.style = .Done
            displayNotificationBanner(withTag: 10, visibility: true)
        }
        else{
            sender.tag = 1
            sender.title = "Edit"
            sender.style = .Plain
            displayNotificationBanner(withTag: 10, visibility: false)
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
        
        let location = Location(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude, context: fetchResultsController!.managedObjectContext)
        annotationMap[annotation] = location
        (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack.save()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
}

