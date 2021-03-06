//
//  InfoViewController.swift
//  OnTheMap
//
//  Created by Huy Tran on 6/8/16.
//  Copyright © 2016 Chris Tran. All rights reserved.
//

import UIKit
import FlatUIKit
import ChameleonFramework
import CoreLocation
import AddressBookUI

class InfoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        findOnTheMapButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        findOnTheMapButton.layer.borderWidth = 1
        findOnTheMapButton.layer.borderColor = UIColor.greenSeaColor().CGColor
        findOnTheMapButton.layer.cornerRadius = 5
        findOnTheMapButton.setTitleColor(UIColor.greenSeaColor(), forState: .Normal)
        
        cancelButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = FlatRedDark().CGColor
        cancelButton.layer.cornerRadius = 5
    }
    
    @IBAction func pressFindOnTheMap(sender: UIButton) {
        
        geoCode(locationTextField.text!)
        
    }
    
    @IBAction func pressCancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func geoCode(address: String) {
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                
                let mapInfoVC = self.storyboard?.instantiateViewControllerWithIdentifier("MapInfoViewController") as? MapInfoViewController
                mapInfoVC!.annotation.coordinate = coordinate!
                mapInfoVC!.mapString = address
                self.presentViewController(mapInfoVC!, animated: true, completion: nil)
            }
        }
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        locationTextField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        locationTextField.resignFirstResponder()
        return true
    }
    
    
    
}
