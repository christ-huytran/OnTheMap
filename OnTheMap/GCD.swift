//
//  GCD.swift
//  OnTheMap
//
//  Created by Huy Tran on 6/4/16.
//  Copyright © 2016 Chris Tran. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}