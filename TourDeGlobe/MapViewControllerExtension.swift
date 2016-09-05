//
//  MapViewControllerExtension.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 02/09/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation
import CoreData
import MapKit
import UIKit

// Extension having code related to Fetching data from Persistent store
extension MapViewController: NSFetchedResultsControllerDelegate{
    // Called whenever fetchResultsController is set
    func getLocations(){
        if let fc = fetchResultsController{
            do{
                // Performing Fetch and loading data into Fetch Results Controller
                try fc.performFetch()
                // Reading Values from Fetch Results Controller and adding previously stored Pins to MapView
                readStoredLocation()
            }catch let e as NSError{
                print("Error while trying to perform a search: \n\(e)\n\(fetchResultsController)")
            }
        }
    }
}

// Extenstion to manage Delegate Methods of Map View
extension MapViewController: MKMapViewDelegate {
    
    // Called whenever a pin's annotation is added to MapView.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        let reusePin = "location"
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reusePin) as? MKPinAnnotationView
        if pin == nil{
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusePin)
            pin?.canShowCallout = false
            pin?.animatesDrop = true
            pin?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else{
            pin?.annotation = annotation
        }
        
        return pin
    }
    
    // Called whenever a Pin is Tapped.
    // This is the handler where we would either be deleting a Pin or Navigating Pin to Photo Album VC depending on 
    // the App State which is being tracked by Flag isDeleteModeOn
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        // Deselecting the selected Pin before performing any other action
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        // Fetching the location associated with the Pin.
        // We use the dictionary which we maintain to get the Location object for the pin just Tapped
        let location = annotationMap[view.annotation as! MKPointAnnotation]
        if(isDeleteModeOn){
            // This block of code gets executed if App is currently in Edit/Delete Mode.
            // Getting reference to Core Data Stack
            let coreDatStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
            
            // Deleting location object from Contenxt
            coreDatStack.context.deleteObject(location!)
            
            // Removing location from temporary dictionary which is keeping track of Location objects for Pins
            annotationMap.removeValueForKey(view.annotation as! MKPointAnnotation)
            
            // Finally Removing Annotation from Map View as well
            mapView.removeAnnotation(view.annotation!)
        }
        else{
            // This block of code gets executed if App is currently in View Mode.
            // Creating instance of Photo Album VC
            let destinationController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageViewControllerId") as! ImageViewController
            
            // Passing Location object whose images are to be shown on Photo Album VC
            destinationController.location = location
            
            // Pushing destination VC on Navigation Bar
            self.navigationController?.pushViewController(destinationController, animated: true)
        }
    }
}

// Extension containing all the methods used by this VC
extension MapViewController{
    
    // Procedure which reads all the stored location and add those locations on Map View using Annotations
    func readStoredLocation() {
        if let fc = fetchResultsController{
            var totalLocations = 0;
            var totalSections = 0;
            
            // The purpose of below for loop is to get the count of total number of annotations.
            // We could have directly accessed Number of objects in Section 0 as there would be just one section.
            // But i wanted to calculate it generically
            // Also to get a location out of fetchResultsController, we must have NSIndexPath. We would be using 
            // number of sections and number of objects in that section to generate index paths which we would
            // be using to get location object from fetchResultsController
            for sec in fc.sections! {
                totalLocations =  totalLocations + sec.numberOfObjects
                totalSections = totalSections + 1
            }
            
            
            print("Totol Locations :\(totalLocations)")
            print("Totol Sections :\(totalSections)")
            var sectionIndex = 0
            var locations = [Location]();
            
            // Iterating through all sections and generating NSIndexPath for each row in each Section
            for sec in fc.sections! {
                var index = 0
                while( index < sec.numberOfObjects){
                    // Initializing NSIndexPath using counters
                    let indexPath = NSIndexPath(forItem: index, inSection: sectionIndex)
                    
                    // Fetching Location object from fetchResultsController using index path
                    let obj = fc.objectAtIndexPath(indexPath)
                    let location = (obj as! Location)
                    
                    // Appending Location to collection of Location Objects
                    locations.append(location)
                    index = index + 1
                }
                
                sectionIndex = sectionIndex + 1
            }
            
            // Iterating through collection of Locations Object and adding Pins to map by creting annotations using 
            // properties of Location Object
            for location in locations{
                let coordinate = CLLocationCoordinate2DMake(Double(location.latitude!), Double(location.longitude!))
                    
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotationMap[annotation] = location
                
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func displayNotificationBanner(withTag tag:Int, visibility isVisible:Bool) -> Void {
        if !isVisible {
            view.viewWithTag(tag)?.removeFromSuperview()
        }
        else{
            let viewFrame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + view.frame.height - CGFloat(64), width: view.frame.width, height: CGFloat(64))
            let bannerView = UIView(frame: viewFrame)
            bannerView.backgroundColor = UIColor.redColor()
            bannerView.tag = tag
            
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(bannerView)
            
            let leading = NSLayoutConstraint(item: bannerView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0)
            let trailing = NSLayoutConstraint(item: bannerView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint(item: bannerView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
            let heightBannerView = NSLayoutConstraint(item: bannerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: CGFloat(64))
            view.addConstraint(leading)
            view.addConstraint(trailing)
            view.addConstraint(bottom)
            view.addConstraint(heightBannerView)
            
            let labelFrame = CGRect(x: bannerView.frame.origin.x, y: bannerView.frame.origin.y, width: bannerView.frame.size.width, height: bannerView.frame.size.height)
            let bannerAlertMessage = UILabel(frame: labelFrame)
            bannerAlertMessage.text = "Tap Pin to Delete"
            bannerAlertMessage.textColor = UIColor.whiteColor()
            bannerAlertMessage.textAlignment = NSTextAlignment.Center;
            let font:UIFont = UIFont(name: "AvenirNext-Medium", size: 20)!
            bannerAlertMessage.font = font;
            bannerAlertMessage.sizeToFit();
            bannerAlertMessage.translatesAutoresizingMaskIntoConstraints = false;
            
            let alertMessageLeadingConstraint = NSLayoutConstraint(item: bannerAlertMessage, attribute: .Leading, relatedBy: .Equal, toItem: bannerView, attribute: .Leading, multiplier: 1, constant: 0)
            let alertMessageTrailiingConstraint = NSLayoutConstraint(item: bannerAlertMessage, attribute: .Trailing, relatedBy: .Equal, toItem: bannerView, attribute: .Trailing, multiplier: 1, constant: 0)
            let alertMessageCenterYConstraint = NSLayoutConstraint(item: bannerAlertMessage, attribute: .CenterY, relatedBy: .Equal, toItem: bannerView, attribute: .CenterY, multiplier: 1, constant: 0)
            
            bannerView.addSubview(bannerAlertMessage)
            bannerView.addConstraint(alertMessageLeadingConstraint)
            bannerView.addConstraint(alertMessageTrailiingConstraint)
            bannerView.addConstraint(alertMessageCenterYConstraint)
        }
    }
}