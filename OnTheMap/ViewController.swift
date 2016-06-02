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

    //@IBOutlet weak var udacityLoginButton: FUIButton!
    
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var udacityLoginButton: FUIButton!
    
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
        
        
        udacityLoginButton.buttonColor = UIColor.turquoiseColor()
        udacityLoginButton.shadowColor = UIColor.greenSeaColor()
        udacityLoginButton.shadowHeight = 3.0
        udacityLoginButton.titleLabel!.font = UIFont.boldFlatFontOfSize(16)
        udacityLoginButton.setTitleColor(UIColor.cloudsColor(), forState:UIControlState.Normal)
        udacityLoginButton.setTitleColor(UIColor.cloudsColor(), forState:UIControlState.Highlighted)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

