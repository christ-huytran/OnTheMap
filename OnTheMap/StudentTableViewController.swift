//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Huy Tran on 6/6/16.
//  Copyright © 2016 Chris Tran. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {

    var locations: [[String:AnyObject]] = []
    
    @IBOutlet weak var studentTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getLocationsFromParseClient()
    }
    
    func getLocationsFromParseClient() {
        ParseClient.sharedInstance().getLocationsData { (results, error) in
            
            guard (error == nil) else {
                print(error)
                return
            }
            
            if let results = results {
                self.locations = results
                performUIUpdatesOnMain({
                    self.studentTableView.reloadData()
                })
            }
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseID = "studentCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseID)!
        let student = locations[indexPath.row]
        
        let first = student["firstName"] as! String
        let last = student["lastName"] as! String
        //let mediaURL = student["mediaURL"] as! String
        
        cell.textLabel?.text = "\(first) \(last)"
        cell.imageView?.image = UIImage(named: "pin")
        //cell.detailTextLabel?.text = "\(mediaURL)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        if let toOpen = locations[indexPath.row]["mediaURL"] as? String {
            app.openURL(NSURL(string: toOpen)!)
        }
    }
    
    @IBAction func postStudentLocation(sender: UIBarButtonItem) {
        ParseClient.sharedInstance().checkStudentLocation { (shouldShowAlert) in
            if shouldShowAlert {
                performUIUpdatesOnMain({
                    self.showAlert()
                })
            } else {
                let InfoVC = self.storyboard!.instantiateViewControllerWithIdentifier("InfoViewController")
                self.presentViewController(InfoVC, animated: true, completion: nil)
            }
        }
    }
    
    private func showAlert() {
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
