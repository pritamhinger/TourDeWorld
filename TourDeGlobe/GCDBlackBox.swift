//
//  GCDBlackBox.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 28/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

func performUIUpdatesOnMainQueue(updates: () -> Void){
    dispatch_async(dispatch_get_main_queue()){
        updates()
    }
}