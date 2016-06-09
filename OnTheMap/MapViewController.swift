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
        ParseClient.sharedInstance().getLocationsData { (results, errorString) in
            
            guard (errorString == nil) else {
                print(errorString)
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
        performUIUpdatesOnMain {
            self.mapView.addAnnotations(annotations)
        }
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

    
    @IBAction func showAlert(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "", message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .Alert)
        
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .Default) { (action) -> Void in
            let InfoVC = self.storyboard!.instantiateViewControllerWithIdentifier("InfoViewController")
            self.presentViewController(InfoVC, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        
        alertController.addAction(overwriteAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
}
