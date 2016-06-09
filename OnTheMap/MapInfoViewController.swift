//
//  MapInfoViewController.swift
//  OnTheMap
//
//  Created by Huy Tran on 6/8/16.
//  Copyright © 2016 Chris Tran. All rights reserved.
//

import UIKit
import MapKit

class MapInfoViewController: UIViewController {
    
    let annotation = MKPointAnnotation()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        annotation.title = "Chris Tran"
        
        delay(1) {
            let span = MKCoordinateSpanMake(1, 1)
            let region = MKCoordinateRegionMake(self.annotation.coordinate, span)
            
            let pinAnnotationView = MKPinAnnotationView(annotation: self.annotation, reuseIdentifier: nil)
            
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(pinAnnotationView.annotation!)
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
}
