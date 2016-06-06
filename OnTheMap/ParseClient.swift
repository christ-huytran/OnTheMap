//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Huy Tran on 6/5/16.
//  Copyright © 2016 Chris Tran. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    var session = NSURLSession.sharedSession()
    
    override init() {
        super.init()
    }
    
    func getLocationsData(completionHandlerForLocationsData: (results: [[String:AnyObject]]!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = NSMutableURLRequest(URL: parseURLFromParameters([:]))
        request.addValue(ParseConstants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseConstants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if error != nil {
                let userInfo = [NSLocalizedDescriptionKey: "There was an error with the request \(error)"]
                completionHandlerForLocationsData(results: nil, error: NSError(domain: "getLocationsData", code: 1, userInfo: userInfo))
            }
            
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON \(data)"]
                completionHandlerForLocationsData(results: nil, error: NSError(domain: "getLocationsData", code: 1, userInfo: userInfo))
            }
            
            guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                print("something went wrong")
                return
            }
            
            completionHandlerForLocationsData(results: results, error: nil)
        }
        
        task.resume()
        
        return task
    }
    
    private func parseURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = ParseConstants.parseScheme
        components.host = ParseConstants.parseHost
        components.path = ParseConstants.parsePath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        
        return components.URL!
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
}