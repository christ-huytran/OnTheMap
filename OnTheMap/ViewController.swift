//
//  ViewController.swift
//  OnTheMap
//
//  Created by Huy Tran on 6/1/16.
//  Copyright © 2016 Chris Tran. All rights reserved.
//

import UIKit
import FlatUIKit
import ChameleonFramework
import TextFieldEffects

class ViewController: UIViewController {

    //@IBOutlet weak var testButton: FUIButton!
    
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backgroundColor = GradientColor(.TopToBottom, frame: (self.navigationController?.navigationBar.frame)!, colors: [FlatPlumDark(), FlatSkyBlueDark()])
        self.view.backgroundColor = FlatBlueDark()
        
        let emailImageView = UIImageView()
        let emailImage = UIImage(named: "email")
        emailImageView.image = emailImage
        emailImageView.frame = CGRect(x: 250, y: 10, width: 20, height: 20)
        emailTextField.addSubview(emailImageView)
        let leftView = UIView.init(frame: CGRectMake(10, 0, 30, 30))
        emailTextField.leftView = leftView
        emailTextField.leftViewMode = UITextFieldViewMode.Always
        
        
        let pwImageView = UIImageView()
        let pwImage = UIImage(named: "lock")
        pwImageView.image = pwImage
        pwImageView.frame = CGRect(x: 250, y: 10, width: 20, height: 20)
        passwordTextField.addSubview(pwImageView)
        let pwleftView = UIView.init(frame: CGRectMake(10, 0, 30, 30))
        passwordTextField.leftView = pwleftView
        passwordTextField.leftViewMode = UITextFieldViewMode.Always
        
        
//        testButton.buttonColor = UIColor.turquoiseColor()
//        testButton.shadowColor = UIColor.greenSeaColor()
//        testButton.shadowHeight = 3.0
//        testButton.cornerRadius = 6.0
//        testButton.titleLabel!.font = UIFont.boldFlatFontOfSize(16) //[UIFont boldFlatFontOfSize:16];
//        testButton.setTitleColor(UIColor.cloudsColor(), forState:UIControlState.Normal)
//        testButton.setTitleColor(UIColor.cloudsColor(), forState:UIControlState.Highlighted)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

