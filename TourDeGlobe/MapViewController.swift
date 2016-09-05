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

class MapViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    // Dictionary to keep track of Location object with Pin placed on Map
    // Key is MKPointAnnotation Object which denotes Pin
    // Value is Location object at that particular Pin
    var annotationMap = [MKPointAnnotation: Location]()
    
    // Flag to keep track of User action when Pins are Tapped
    // Since we are using same event to delete as well as to navigate to PhotoAlbum, we need to keep track of state
    // so that proper action can be taken
    var isDeleteModeOn = false
    
    var fetchResultsController: NSFetchedResultsController?{
        didSet{
            fetchResultsController?.delegate = self
            getLocations()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting Map View Delegte
        mapView.delegate = self
        // Hidding User Location
        mapView.showsUserLocation = false
        // Enabling Zoom on Maps
        mapView.zoomEnabled = true
        
        
        let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
        
        // Preparing Fetch Request to Load already saved Location by User in previous session.
        let fetchRequest = NSFetchRequest(entityName: CoreDataStack.EntityName.Location)
        
        // Setting Sort Descriptors to Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Adding 'Long Press Gesture Recognizer' to Map. We would be adding Pin on map in the handler of this event
        let tapGestureReconizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.tap(_:)))
        view.addGestureRecognizer(tapGestureReconizer)
        
        self.navigationItem.title = "Tour De Globe"
    }
    
    // Mark: - IBActions
    // The below Event Handler switch the App State between Editing and Viewing
    @IBAction func editingSwitched(sender: UIBarButtonItem) {
        
        if sender.tag == AppConstants.ViewTag.EditButtonTag{
            // This code gets executed when the Bar Button was previously in View Mode
            // Now we are changing app state to be in Edit Mode. In edit mode, user can delete a pin and images
            // associated with the location which is associated with Pin
            
            // Setting a different Tag as we are using Tag Value to decide app State
            sender.tag = AppConstants.ViewTag.DoneButtonTag
            
            // Chaning Bar Button Title to Done
            sender.title = AppConstants.BarButtonTitle.Done
            
            // Chaning Bar Button Style
            sender.style = .Done
            
            // Calling procedure which add a banner at the bottom of the VC
            displayNotificationBanner(withTag: AppConstants.ViewTag.BannerViewTag, visibility: true)
            
            // Setting flag which keep track of App's Edit/View mode
            isDeleteModeOn = true
        }
        else{
            // Changing App State to be in View Mode
            
            // Restoring tag of Bar Button to Its original Value
            sender.tag = AppConstants.ViewTag.EditButtonTag
            
            // Restoring title of the Bar Button to Edit
            sender.title = AppConstants.BarButtonTitle.Edit
            
            sender.style = .Plain
            isDeleteModeOn = false
            
            // Calling procedure to remove the banner
            displayNotificationBanner(withTag: AppConstants.ViewTag.BannerViewTag, visibility: false)
        }
        
    }
    
    // MARK: - Tap Gesture Handlers
    func tap(sender: UILongPressGestureRecognizer) {
        
        // The event is called two times. First when tap starts and second time when tap ends.
        // Since we are only interested in the state where User releases Tap.
        // Thus we are return without doing anything for all states other than Ended
        if sender.state != UIGestureRecognizerState.Ended{
            return
        }
        
        // Getting location where User Tapped on Map.
        // This is a CGPoint Object.
        let touchedLocation = sender.locationInView(mapView)
        
        // Converting tapped location into an object of CLLocationCoordinate2D using MapView API
        let locationCoordinate = mapView.convertPoint(touchedLocation, toCoordinateFromView: mapView)
        
        // Initiazing Annotation object for adding a pin
        let annotation = MKPointAnnotation()
        
        // Setting tapped location coordinate object to pin's annotation object
        annotation.coordinate = locationCoordinate
        
        // Adding Annotation object to Map. This would actually drop a pin on Map
        mapView.addAnnotation(annotation)
        
        // Initializing Location object from tapped location coordinate properties
        let location = Location(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude, context: fetchResultsController!.managedObjectContext)
        
        // Adding Pin's Annotation object and Location object to dictionary.
        // We will be using this dictionary to fetch Location object when pin is tapped.
        annotationMap[annotation] = location
        
        // Saving changes to Context. This would save this tapped location in app's persistent storage.
        // When next time user launches this app. This particular pin would be added by default. 
        (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack.save()
    }
    
    // Mark: - UIPopoverPresentationControllerDelegate Methods
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    // Mark: - View Controller Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == AppConstants.SegueIdentifier.PreferenceSegue{
            let controller = segue.destinationViewController as! PreferenceViewController
            controller.modalPresentationStyle = UIModalPresentationStyle.Popover
            controller.popoverPresentationController?.delegate = self
        }
    }
}

