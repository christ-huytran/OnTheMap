//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Huy Tran on 6/2/16.
//  Copyright © 2016 Chris Tran. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {

    var session = NSURLSession.sharedSession()
    var userID: Int?
    var firstName: String?
    var lastName: String?
    
    override init() {
        super.init()
    }
    
    func authenticateWithViewController(jsonBody: String, completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
        
        
        
    }
    
    private func getUserID(jsonBody: String, completionHandlerForUserID: (success: Bool, userID: Int?, errorString: String?)) {
        let parameters = [String:AnyObject]()
        taskForPOSTMethod(Methods.AuthenticationSessionNew, parameters: parameters, jsonBody: jsonBody) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForAuth(success: false, errorString: "Login failed. Please log in again!")
                return
            }
            
            guard let account = result[JSONResponseKeys.Account] as? [String:AnyObject] else {
                completionHandlerForAuth(success: false, errorString: "Login failed. Please log in again!")
                return
            }
            
            guard let registered = account[JSONResponseKeys.Registered] as? Int where registered == 1 else {
                completionHandlerForAuth(success: false, errorString: "Login failed. Please log in again!")
                return
            }
            
            guard let userID = account[JSONResponseKeys.Key] as? Int else {
                completionHandlerForAuth(success: false, errorString: "Login failed. Please log in again!")
                return
            }
            
            self.userID = userID
            
            completionHandlerForAuth(success: true, errorString: nil)
        }
    }
    
    func taskForGETMethod(method: String, parameters: [String:AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: udacityURLFromParameters(parameters, withPathExtension: method))
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if error != nil {
                return
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)
            
        }
        
        task.resume()
        
        return task
    }
    
    func taskForPOSTMethod(method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {

        let request = NSMutableURLRequest(URL: udacityURLFromParameters(parameters, withPathExtension: method))
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if error != nil {
                return
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            
            // print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
            
        }
        
        task.resume()
        
        return task
    }
    
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(result: parsedResult, error: nil)
        
    }
    
    private func udacityURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.udacityScheme
        components.host = Constants.udacityHost
        components.path = (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
