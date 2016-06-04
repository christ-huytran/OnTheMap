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
    var sessionID: String?
    
    override init() {
        super.init()
    }
    
    func authenticateWithViewController(jsonBody: String, completionHandlerForAuth: (success: Bool, errorString: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        taskForPOSTMethod(Methods.AuthenticationSessionNew, parameters: parameters, jsonBody: jsonBody) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForAuth(success: false, errorString: error)
                return
            }
            
            guard let account = result[JSONResponseKeys.Account] as? [String:AnyObject] else {
                let userInfo = [NSLocalizedDescriptionKey: "Could not find key \(JSONResponseKeys.Account) in result JSON"]
                completionHandlerForAuth(success: false, errorString: NSError(domain: "authenticateWithViewController", code: 1, userInfo: userInfo))
                return
            }
            
            guard let registered = account[JSONResponseKeys.Registered] as? Int where registered == 1 else {
                let userInfo = [NSLocalizedDescriptionKey: "Authentication with Udacity failed"]
                completionHandlerForAuth(success: false, errorString: NSError(domain: "authenticateWithViewController", code: 1, userInfo: userInfo))
                return
            }
            
            completionHandlerForAuth(success: true, errorString: nil)
            
        }
        
    }
    
    func taskForPOSTMethod(method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {

        let request = NSMutableURLRequest(URL: udacityURLFromParameter(parameters, withPathExtension: method))
        print(udacityURLFromParameter(parameters, withPathExtension: method))
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
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(newData)'"]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            completionHandlerForPOST(result: parsedResult, error: nil)
        }
        
        task.resume()
        
        return task
    }
    
    private func udacityURLFromParameter(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
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
