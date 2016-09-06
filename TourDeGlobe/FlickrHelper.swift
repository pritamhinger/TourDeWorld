//
//  FlickrHelper.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 28/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation
import UIKit

extension FlickrClient{
    
    // MARK: - Flickr Helper Methods
    // Below method is used to get photos based on the Parameters passed
    func getPhotos(methodName:String, parameters: [String:String], completionHandler: (results:AnyObject?, error:NSError?) -> Void) {
        FlickrClient.sharedInstance().taskForGetMethod(methodName, parameter: parameters){ (results, error) in
            if error == nil{
                completionHandler(results: results, error: nil)
            }
            else{
                completionHandler(results: nil, error: error);
            }
        }
        
    }
    
    func getImageDataFromURL(url: String, completionHandler: (imageData:NSData?, error: NSError?) -> Void) {
        FlickrClient.sharedInstance().taskToFetchImage(url){(result, error) in
            if error == nil{
                if let data = result as? NSData{
                    completionHandler(imageData: data, error: nil)
                }
                else{
                    completionHandler(imageData: nil, error: NSError(domain: "DataFormatError", code: 1, userInfo: nil))
                }
                
            }
            else{
                completionHandler(imageData: nil, error: error)
            }
        }
    }
    
    // MARK: - Class Methods
    static func flickrURLFromParameters(parameters: [String:AnyObject]) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = FlickrClient.APIResource.Scheme
        components.host = FlickrClient.APIResource.Host
        components.path = FlickrClient.APIResource.Path
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    static func addCommonParameters(methodName: String, parameters: [String:String]) -> [String:String]{
        var queryParameters = parameters
        queryParameters[FlickrClient.QueryParameterKeys.APIKey] = FlickrClient.APIResource.APIKey
        queryParameters[FlickrClient.QueryParameterKeys.Method] = methodName
        queryParameters[FlickrClient.QueryParameterKeys.Extras] = FlickrClient.QueryParameterValues.MediumURL
        queryParameters[FlickrClient.QueryParameterKeys.Format] = FlickrClient.QueryParameterValues.ResponseFormat
        queryParameters[FlickrClient.QueryParameterKeys.NoJSONCallback] = FlickrClient.QueryParameterValues.DisableJSONCallBack
        queryParameters[FlickrClient.QueryParameterKeys.SafeSearch] = FlickrClient.QueryParameterValues.UseSafeSearch
        
        return queryParameters
    }
    
    static func addQueryParametersFromPreference(parameters:[String:String]) -> [String:String]{
        var queryParameters = parameters
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let radius = userDefaults.valueForKey(FlickrClient.QueryParameterKeys.Radius){
            queryParameters[FlickrClient.QueryParameterKeys.Radius] = "\(radius)"
        }
        else{
            userDefaults.setValue(FlickrClient.Default.Radius, forKey: FlickrClient.QueryParameterKeys.Radius)
            queryParameters[FlickrClient.QueryParameterKeys.Radius] = FlickrClient.Default.Radius
        }
        
        if let radiusUnit = userDefaults.valueForKey(FlickrClient.QueryParameterKeys.RadiusUnits){
            queryParameters[FlickrClient.QueryParameterKeys.RadiusUnits] = "\(radiusUnit)"
        }
        else{
            userDefaults.setValue(FlickrClient.Default.RadiusUnit, forKey: FlickrClient.QueryParameterKeys.RadiusUnits)
            queryParameters[FlickrClient.QueryParameterKeys.RadiusUnits] = FlickrClient.Default.RadiusUnit
        }
        
        if let perPage = userDefaults.valueForKey(FlickrClient.QueryParameterKeys.PerPage) as? Int{
            queryParameters[FlickrClient.QueryParameterKeys.PerPage] = "\(perPage)"
        }
        else{
            userDefaults.setInteger(FlickrClient.Default.PerPage, forKey: FlickrClient.QueryParameterKeys.PerPage)
            queryParameters[FlickrClient.QueryParameterKeys.PerPage] = "\(FlickrClient.Default.PerPage)"
        }
        
        return queryParameters
    }
}