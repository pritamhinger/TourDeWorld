//
//  PreferenceViewController.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 05/09/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class PreferenceViewController: UIViewController {

    
    @IBOutlet weak var distanceUnitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var radiusStepper: UIStepper!
    
    @IBOutlet weak var perPageCountStepper: UIStepper!
    @IBOutlet weak var perPageCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let radius = userDefaults.valueForKey(FlickrClient.QueryParameterKeys.Radius){
            radiusLabel.text = radius as? String
        }
        else{
            userDefaults.setValue(FlickrClient.Default.Radius, forKey: FlickrClient.QueryParameterKeys.Radius)
            radiusLabel.text = FlickrClient.Default.Radius
        }
        
        if let radiusUnit = userDefaults.valueForKey(FlickrClient.QueryParameterKeys.RadiusUnits){
            if (radiusUnit as! String) == FlickrClient.RadiusUnit.Kms{
                distanceUnitSegmentedControl.selectedSegmentIndex = 0
                radiusStepper.maximumValue = Double(32)
            }
            else{
                distanceUnitSegmentedControl.selectedSegmentIndex = 1
                radiusStepper.maximumValue = Double(20)
            }
        }
        else{
            userDefaults.setValue(FlickrClient.Default.RadiusUnit, forKey: FlickrClient.QueryParameterKeys.RadiusUnits)
            radiusStepper.maximumValue = Double(32)
        }
        
        if let perPageCount = userDefaults.valueForKey(FlickrClient.QueryParameterKeys.PerPage) as? Int{
            perPageCountLabel.text = "\(perPageCount)"
        }
        else{
            perPageCountLabel.text = "\(FlickrClient.Default.PerPage)"
            userDefaults.setInteger(FlickrClient.Default.PerPage, forKey: FlickrClient.QueryParameterKeys.PerPage)
        }
        
        perPageCountStepper.value = Double(perPageCountLabel.text!)!
    }

    @IBAction func unitChanged(sender: UISegmentedControl) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let radius = userDefaults.valueForKey(FlickrClient.QueryParameterKeys.Radius) as? String{
            if let radius = Int(radius){
                if sender.selectedSegmentIndex == 0{
                    radiusLabel.text = "\(Int(Double(radius) * 1.6))"
                    userDefaults.setValue(FlickrClient.RadiusUnit.Kms, forKey: FlickrClient.QueryParameterKeys.RadiusUnits)
                    radiusStepper.maximumValue = 32
                }
                else{
                    radiusLabel.text = "\(Int(Double(radius) / 1.6))"
                    userDefaults.setValue(FlickrClient.RadiusUnit.Miles, forKey: FlickrClient.QueryParameterKeys.RadiusUnits)
                    radiusStepper.maximumValue = 20
                }
                
                radiusStepper.value = Double(radiusLabel.text!)!
                userDefaults.setValue(radiusLabel.text!, forKey: FlickrClient.QueryParameterKeys.Radius)
            }
        }
    }
    
    @IBAction func perPageImageCountChanged(sender: UIStepper) {
        let value = sender.value
        let userDefaults = NSUserDefaults.standardUserDefaults()
        perPageCountLabel.text = "\(Int(value))"
        userDefaults.setInteger(Int(value), forKey: FlickrClient.QueryParameterKeys.PerPage)
    }
    
    @IBAction func radiusValueChanged(sender: UIStepper) {
        let value = sender.value
        let userDefaults = NSUserDefaults.standardUserDefaults()
        radiusLabel.text = "\(Int(value))"
        userDefaults.setValue(radiusLabel.text!, forKey: FlickrClient.QueryParameterKeys.Radius)
    }
}
