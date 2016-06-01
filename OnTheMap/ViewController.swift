//
//  ViewController.swift
//  OnTheMap
//
//  Created by Huy Tran on 6/1/16.
//  Copyright © 2016 Chris Tran. All rights reserved.
//

import UIKit
import FlatUIKit

class ViewController: UIViewController {

    @IBOutlet weak var testButton: FUIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testButton.buttonColor = UIColor.turquoiseColor()
        testButton.shadowColor = UIColor.greenSeaColor()
        testButton.shadowHeight = 3.0
        testButton.cornerRadius = 6.0
        testButton.titleLabel!.font = UIFont.boldFlatFontOfSize(16) //[UIFont boldFlatFontOfSize:16];
        testButton.setTitleColor(UIColor.cloudsColor(), forState:UIControlState.Normal)
        testButton.setTitleColor(UIColor.cloudsColor(), forState:UIControlState.Highlighted)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

