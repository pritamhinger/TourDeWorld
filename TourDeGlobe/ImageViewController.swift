//
//  ImageViewController.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 04/09/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var location:Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Tapped Location is \(location!)")
    }
}
