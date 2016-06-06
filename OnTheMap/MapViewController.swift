//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Huy Tran on 6/5/16.
//  Copyright © 2016 Chris Tran. All rights reserved.
//

import UIKit
import MapKit
import ChameleonFramework

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var locations: [[String:AnyObject]]!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocationsFromParseClient()
    }
    
    func getLocationsFromParseClient() {
        ParseClient.sharedInstance().getLocationsData { (result, error) in
            
            guard (error == nil) else {
                print(error)
                return
            }
            
            guard let results = result["results"] as? [[String:AnyObject]] else {
                print("something went wrong")
                return
            }
            
            self.locations = results
            self.addAnnotationsToMapView()
        }
    }
    
    private func addAnnotationsToMapView() {
        var annotations = [MKPointAnnotation]()
        
        for dictionary in locations {
            let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
            let long = CLLocationDegrees(dictionary["longitude"] as! Double)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary["firstName"] as! String
            let last = dictionary["lastName"] as! String
            let mediaURL = dictionary["mediaURL"] as! String
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }

}
