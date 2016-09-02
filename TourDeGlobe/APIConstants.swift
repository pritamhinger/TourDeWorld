//
//  Constants.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 28/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

extension FlickrClient{
    
    // MARK: - Constants for Rest Call URL
    struct APIResource {
        static let Scheme = "https"
        static let Host = "api.flickr.com"
        static let Path = "/services/rest"
        static let APIKey = "954afa5e9abf813f08eb56aace2a7dda"
    }
    
    // MARK: - Flickr API Method Names
    struct APIMethod{
        static let PhotosSearch = "flickr.photos.search"
    }
    
    // MARK: - Keys of Query Parameter
    struct QueryParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Latitude = "lat"
        static let Longitude = "lon"
        static let Radius = "radius"
        static let RadiusUnits = "radius_uints"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Extras = "extras"
    }
    
    // MARK: - Values of Query Parameter which are Constant always
    struct  QueryParameterValues {
        static let ResponseFormat = "json"
        static let DisableJSONCallBack = "1"
        static let UseSafeSearch = "1"
        static let MediumURL = "url_m"
    }
    
    struct Default {
        static let Radius = "5"
        static let RadiusUnit = "km"
    }
    
}