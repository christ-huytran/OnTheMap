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
    
    func checkStudentLocation(completionHandlerForCheckLocation: (shouldShowAlert: Bool) -> Void) {
        var parameters = [String:AnyObject]()
        parameters[ParameterKeys.Where] = "{\"\(ParameterKeys.UniqueKey)\":\"\(UdacityClient.sharedInstance().userID)\"}"
        let request = generateRequestToParse(parameters, withPathExtension: Methods.StudentLocation)
        
        sendRequestToParse(request) { (result, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            guard let results = result[JSONResponseKeys.Results] as? [[String:AnyObject]] else {
                completionHandlerForCheckLocation(shouldShowAlert: false)
                return
            }
            
            if results.count > 0 {
                completionHandlerForCheckLocation(shouldShowAlert: true)
            } else {
                completionHandlerForCheckLocation(shouldShowAlert: false)
            }
        }
    }
    
    func postStudentLocation(jsonBody: String, completionHandlerForPostStudentLocation: () -> Void) {
        let request = generateRequestToParse([:], withPathExtension: Methods.StudentLocation)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        sendRequestToParse(request) { (result, error) in
            completionHandlerForPostStudentLocation()
        }
    }
    
    func getLocationsData(completionHandlerForLocationsData: (results: [[String:AnyObject]]!, errorString: String?) -> Void) {
        
        let request = generateRequestToParse([:], withPathExtension: Methods.StudentLocation)
        
        sendRequestToParse(request) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForLocationsData(results: nil, errorString: "Cannot get location data")
                return
            }
            
            guard let results = result[JSONResponseKeys.Results] as? [[String:AnyObject]] else {
                completionHandlerForLocationsData(results: nil, errorString: "Cannot get location data")
                return
            }
            
            completionHandlerForLocationsData(results: results, errorString: nil)
            
        }
    }
    
    private func sendRequestToParse(request: NSMutableURLRequest, completionHandlerForParse: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if error != nil {
                let userInfo = [NSLocalizedDescriptionKey: "There was an error with the request \(error)"]
                completionHandlerForParse(result: nil, error: NSError(domain: "getLocationsData", code: 1, userInfo: userInfo))
            }
            
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON \(data)"]
                completionHandlerForParse(result: nil, error: NSError(domain: "sendRequestToParse", code: 1, userInfo: userInfo))
            }
            
            completionHandlerForParse(result: parsedResult, error: nil)
        }
        
        task.resume()
        
        return task
    }
    
    private func generateRequestToParse(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: parseURLFromParameters(parameters, withPathExtension: withPathExtension))
        request.addValue(ParseConstants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseConstants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        return request
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