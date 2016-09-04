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

extension MapViewController: NSFetchedResultsControllerDelegate{
    func getLocations(){
        if let fc = fetchResultsController{
            do{
                try fc.performFetch()
                readStoredLocation()
            }catch let e as NSError{
                print("Error while trying to perform a search: \n\(e)\n\(fetchResultsController)")
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
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
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        self.performSegueWithIdentifier(AppConstants.SegueIdentifier.ViewImageForLocationSegue, sender: view)
    }
}

extension MapViewController{
    func readStoredLocation() {
        if let fc = fetchResultsController{
            var totalLocations = 0;
            var totalSections = 0;
            for sec in fc.sections! {
                totalLocations =  totalLocations + sec.numberOfObjects
                totalSections = totalSections + 1
            }
            
            print("total locations are : \(totalLocations)")
            print("total sections are : \(totalSections)")
            
            var sectionIndex = 0
            var locations = [Location]();
            for sec in fc.sections! {
                var index = 0
                while( index < sec.numberOfObjects){
                    let indexPath = NSIndexPath(forItem: index, inSection: sectionIndex)
                    let obj = fc.objectAtIndexPath(indexPath)
                    let location = (obj as! Location)
                    locations.append(location)
                    index = index + 1
                }
                
                sectionIndex = sectionIndex + 1
            }
            
            for location in locations{
                let coordinate = CLLocationCoordinate2DMake(Double(location.latitude!), Double(location.longitude!))
                    
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotationMap[annotation] = location
                self.mapView.addAnnotation(annotation)
            }
        }
    }
}