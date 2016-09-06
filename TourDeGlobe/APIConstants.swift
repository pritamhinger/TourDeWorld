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
        static let Page = "page"
        static let PerPage = "per_page"
    }
    
    // MARK: - Values of Query Parameter which are Constant always
    struct  QueryParameterValues {
        static let ResponseFormat = "json"
        static let DisableJSONCallBack = "1"
        static let UseSafeSearch = "1"
        static let MediumURL = "url_m"
    }
    
    // MARK: - Default Values of API Parameters
    struct Default {
        static let Radius = "5"
        static let RadiusUnit = "km"
        static let PerPage = 10
    }
    
    // MARK: - Radius Units
    struct RadiusUnit {
        static let Kms = Default.RadiusUnit
        static let Miles = "mi"
    }
    
    // MARK: - Keys in Flickr Response 
    struct  FlickResponseKeys {
        static let ImageURL = "url_m"
        static let ImageId = "id"
        static let ImageOwner = "owner"
        static let Secret = "secret"
        static let Farm = "farm"
        static let Title = "title"
        static let ImageHeight = "height_m"
        static let ImageWidth = "width_m"
        static let CurrentPageNumber = "page"
        static let TotalPages = "pages"
        static let PerPageCount = "perpage"
        static let TotalCount = "total"
        static let Photos = "photos"
        static let Photo = "photo"
    }
}