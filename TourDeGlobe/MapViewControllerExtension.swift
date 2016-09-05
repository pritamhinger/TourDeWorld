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
        let location = annotationMap[view.annotation as! MKPointAnnotation]
        if(isDeleteModeOn){
            let coreDatStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
            
            coreDatStack.context.deleteObject(location!)
            annotationMap.removeValueForKey(view.annotation as! MKPointAnnotation)
            mapView.removeAnnotation(view.annotation!)
        }
        else{
            let destinationController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageViewControllerId") as! ImageViewController
            destinationController.location = location
            self.navigationController?.pushViewController(destinationController, animated: true)
        }
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
            
            
            print("Totol Locations :\(totalLocations)")
            print("Totol Sections :\(totalSections)")
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