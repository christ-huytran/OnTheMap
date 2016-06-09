//
//  Constants.swift
//  OnTheMap
//
//  Created by Huy Tran on 6/2/16.
//  Copyright © 2016 Chris Tran. All rights reserved.
//

import Foundation

struct UdacityConstants {
    
    // MARK: URLs
    static let udacityScheme = "https"
    static let udacityHost = "www.udacity.com"
    
}

struct Methods {
    
    // MARK: Authentication
    static let AuthenticationSessionNew = "/api/session"
    static let PublicUserData = "/api/users/{id}"
    static let StudentLocation = "/classes/StudentLocation"
    
}

struct ParameterKeys {
    static let Where = "where"
    static let UniqueKey = "uniqueKey"
}

struct JSONResponseKeys {
    
    static let Account = "account"
    static let Registered = "registered"
    static let Key = "key"
    static let Results = "results"
    static let User = "user"
    static let FirstName = "first_name"
    static let LastName = "last_name"
    
}

struct ParseConstants {
    
    static let parseScheme = "https"
    static let parseHost = "api.parse.com"
    static let parsePath = "/1"
    static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
}