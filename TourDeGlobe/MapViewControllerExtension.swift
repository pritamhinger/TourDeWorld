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
    func getLocations() -> [MKPointAnnotation]{
        if let fc = fetchResultsController{
            do{
                try fc.performFetch()
                return readStoredLocation()
            }catch let e as NSError{
                print("Error while trying to perform a search: \n\(e)\n\(fetchResultsController)")
                return [MKPointAnnotation]()
            }
        }
        
        return [MKPointAnnotation]()
    }
}

extension MapViewController{
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        print("Adding annotation. Coordinate is: \(annotation.coordinate)")
        if annotation is MKUserLocation{
            return nil
        }
        
        let reusePin = "location"
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reusePin) as? MKPinAnnotationView
        if pin == nil{
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusePin)
            pin?.canShowCallout = true
            pin?.animatesDrop = true
            pin?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else{
            pin?.annotation = annotation
        }
        
        return pin
    }
}

extension MapViewController{
    func readStoredLocation() -> [MKPointAnnotation] {
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
            
            var annotations = [MKPointAnnotation]()
            //performUIUpdatesOnMainQueue{
                var i = 1;
                for location in locations{
                    let coordinate = CLLocationCoordinate2DMake(Double(location.latitude!), Double(location.longitude!))
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = "Title No. \(i)"
                    i = i + 1
                    annotation.coordinate = coordinate
                    annotations.append(annotation)
                }
                //}
            return annotations
        }
        
        return [MKPointAnnotation]()
    }
}