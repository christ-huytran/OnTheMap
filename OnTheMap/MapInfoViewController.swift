//
//  MapInfoViewController.swift
//  OnTheMap
//
//  Created by Huy Tran on 6/8/16.
//  Copyright © 2016 Chris Tran. All rights reserved.
//

import UIKit
import MapKit
import FlatUIKit
import ChameleonFramework

class MapInfoViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    let annotation = MKPointAnnotation()
    var mapString: String!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var shareLinkTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        annotation.title = "Chris Tran"
        
        addButtonsToView()
        
        delay(1) {
            let span = MKCoordinateSpanMake(1, 1)
            let region = MKCoordinateRegionMake(self.annotation.coordinate, span)
            
            let pinView = MKPinAnnotationView(annotation: self.annotation, reuseIdentifier: nil)
            pinView.canShowCallout = true
            pinView.pinTintColor = UIColor.redColor()
            pinView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(pinView.annotation!)
        }
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func addButtonsToView() {
        // MARK: submitButton
        let submitButton = FUIButton()
        submitButton.frame = CGRectMake(self.view.frame.width/4, self.view.frame.size.height - 90, self.view.frame.size.width/2, 30)
        submitButton.buttonColor = UIColor.turquoiseColor()
        submitButton.shadowColor = UIColor.greenSeaColor()
        submitButton.shadowHeight = 3.0
        submitButton.layer.cornerRadius = 5
        submitButton.setTitleColor(.whiteColor(), forState: .Normal)
        submitButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        submitButton.setTitle("Submit", forState: UIControlState.Normal)
        submitButton.addTarget(self, action: #selector(MapInfoViewController.pressSubmitLocation), forControlEvents: .TouchUpInside)
        
        // MARK: cancelButton
        let cancelButton = FUIButton()
        cancelButton.frame = CGRectMake(self.view.frame.width/4, self.view.frame.size.height - 50, self.view.frame.size.width/2, 30)
        cancelButton.buttonColor = UIColor.alizarinColor()
        cancelButton.shadowColor = UIColor.flatRedColorDark()
        cancelButton.shadowHeight = 3.0
        cancelButton.layer.cornerRadius = 5
        cancelButton.setTitleColor(.whiteColor(), forState: .Normal)
        cancelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: #selector(MapInfoViewController.pressCancel), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(submitButton)
        self.view.addSubview(cancelButton)
    }
    
    func pressSubmitLocation() {
        let jsonBody = "{\"uniqueKey\": \(UdacityClient.sharedInstance().userID!), \"firstName\": \"\(UdacityClient.sharedInstance().firstName!)\", \"lastName\": \"\(UdacityClient.sharedInstance().lastName!)\", \"mapString\": \"\(mapString)\", \"mediaURL\": \"https://\(shareLinkTextField.text!)\", \"latitude\": \(annotation.coordinate.latitude), \"longitude\": \(annotation.coordinate.longitude)}"
        print(jsonBody)
        
//        ParseClient.sharedInstance().postStudentLocation(jsonBody) {
//            let presentingViewController = self.presentingViewController
//            self.dismissViewControllerAnimated(false, completion: {
//                presentingViewController!.dismissViewControllerAnimated(true, completion: {})
//            })
//        }
    }
    
    func pressCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: TextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        shareLinkTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        shareLinkTextField.text = ""
    }
}
