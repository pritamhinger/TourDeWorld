//
//  AppConstants.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 04/09/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

struct AppConstants {
    struct SegueIdentifier {
        static let PreferenceSegue = "preferenceSegue"
    }
    
    struct CellIdentifier {
        static let FlickrImageViewCell = "flickrImageViewCell"
    }
    
    struct BarButtonTitle {
        static let Done = "Done"
        static let Edit = "Edit"
        static let NewCollection = "New Collection"
        static let RemoveSelectedImage = "Remove Selected Images"
    }
    
    struct ViewTag {
        static let EditButtonTag = 1
        static let DoneButtonTag = 2
        static let BannerViewTag = 3
    }
    
    static let DetailViewMapLatitudeZoomLevel = 50.0
    static let DetailViewMapLongitudeZoomLevel = 50.0
    
}