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
        
        getUserID(jsonBody) { (success, userID, errorString) in
            if success {
                self.userID = userID
                self.getUserInfo({ (success, firstName, lastName, errorString) in
                    if success {
                        self.firstName = firstName!
                        self.lastName = lastName!
                        completionHandlerForAuth(success: success, errorString: errorString)
                    } else {
                        completionHandlerForAuth(success: success, errorString: errorString)
                    }
                })
            } else {
                completionHandlerForAuth(success: success, errorString: errorString)
            }
        }
        
    }
    
    private func getUserInfo(completionHandlerForUserInfo: (success: Bool, firstName: String?, lastName: String?, errorString: String?) -> Void) {
        let parameters = [String:AnyObject]()
        let method = substituteKeyInMethod(Methods.PublicUserData, key: "id", value: String(UdacityClient.sharedInstance().userID!))!
        taskForGETMethod(method, parameters: parameters) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForUserInfo(success: false, firstName: nil, lastName: nil, errorString: "Cannot get user info")
                return
            }
            
            guard let userInfo = result[JSONResponseKeys.User] as? [String:AnyObject] else {
                completionHandlerForUserInfo(success: false, firstName: nil, lastName: nil, errorString: "Cannot get user info")
                return
            }
            
            guard let firstName = userInfo[JSONResponseKeys.FirstName] as? String else {
                completionHandlerForUserInfo(success: false, firstName: nil, lastName: nil, errorString: "Cannot get user first name")
                return
            }
            
            guard let lastName = userInfo[JSONResponseKeys.LastName] as? String else {
                completionHandlerForUserInfo(success: false, firstName: firstName, lastName: nil, errorString: "Cannot get user last name")
                return
            }
            
            completionHandlerForUserInfo(success: true, firstName: firstName, lastName: lastName, errorString: nil)
            
        }
    }
    
    private func getUserID(jsonBody: String, completionHandlerForUserID: (success: Bool, userID: Int?, errorString: String?) -> Void) {
        let parameters = [String:AnyObject]()
        taskForPOSTMethod(Methods.AuthenticationSessionNew, parameters: parameters, jsonBody: jsonBody) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForUserID(success: false, userID: nil, errorString: "Login failed. Please log in again!")
                return
            }
            
            guard let account = result[JSONResponseKeys.Account] as? [String:AnyObject] else {
                completionHandlerForUserID(success: false, userID: nil, errorString: "Login failed. Please log in again!")
                return
            }
            
            guard let registered = account[JSONResponseKeys.Registered] as? Int where registered == 1 else {
                completionHandlerForUserID(success: false, userID: nil, errorString: "Login failed. Please log in again!")
                return
            }
            
            guard let userID = account[JSONResponseKeys.Key] as? String else {
                completionHandlerForUserID(success: false, userID: nil, errorString: "Login failed. Please log in again!")
                return
            }
            
            completionHandlerForUserID(success: true, userID: Int(userID), errorString: nil)
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
    
    func substituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    private func udacityURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = UdacityConstants.udacityScheme
        components.host = UdacityConstants.udacityHost
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
