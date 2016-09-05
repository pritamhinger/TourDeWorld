//
//  CoreDataConstants.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 02/09/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

extension CoreDataStack{
    
    // MARK: - Entity Names
    struct EntityName {
        static let Image = "Image"
        static let Location = "Location"
    }
    
    // MARK: - Model Names
    struct  ModelName {
        static let AppData = "AppData"
    }
    
    // MARK: - Constants Used by CoreData Layer
    struct Constants {
        static let DelaysInSeconds = 15
        static let DropData = false
    }
}