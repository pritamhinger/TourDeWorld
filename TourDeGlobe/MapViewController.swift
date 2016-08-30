//
//  ViewController.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 28/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}

