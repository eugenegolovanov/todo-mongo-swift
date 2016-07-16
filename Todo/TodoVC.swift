//
//  ViewController.swift
//  Todo
//
//  Created by eugene golovanov on 7/14/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit

class TodoVC: UIViewController {

    
    //--------------------------------------------------------------------------------------------------
    //MARK: - Properties

    
    
    
    //--------------------------------------------------------------------------------------------------
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        

        if let token = NSUserDefaults.standardUserDefaults().stringForKey(KEY_TOKEN) {
            print("Token:\n\(token)")
        } else {
            performSegueWithIdentifier("loginSegue", sender: self)
        }
        

    }
    
    
    //--------------------------------------------------------------------------------------------------
    //MARK: - Actions

    @IBAction func onLogoutButton(sender: UIButton) {
        
        deleteToken()
        performSegueWithIdentifier("loginSegue", sender: self)

        
    }
    

}

