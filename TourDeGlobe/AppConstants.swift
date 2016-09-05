//
//  AppConstants.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 04/09/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

struct AppConstants {
    // MARK: - Segue Identifier
    struct SegueIdentifier {
        static let PreferenceSegue = "preferenceSegue"
    }
    
    // MARK: - Cell Identifier
    struct CellIdentifier {
        static let FlickrImageViewCell = "flickrImageViewCell"
    }
    
    // MARK: - Bar Button Titles
    struct BarButtonTitle {
        static let Done = "Done"
        static let Edit = "Edit"
        static let NewCollection = "New Collection"
        static let RemoveSelectedImage = "Remove Selected Images"
    }
    
    // MARK: - View Tags
    struct ViewTag {
        static let EditButtonTag = 1
        static let DoneButtonTag = 2
        static let BannerViewTag = 3
    }
    
    // MARK: - Other Constants
    static let DetailViewMapLatitudeZoomLevel = 50.0
    static let DetailViewMapLongitudeZoomLevel = 50.0
    
}