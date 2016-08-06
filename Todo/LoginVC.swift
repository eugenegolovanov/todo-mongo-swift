//
//  LoginVC.swift
//  Todo
//
//  Created by eugene golovanov on 7/14/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    //--------------------------------------------------------------------------------------------------
    //MARK: - Properties

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    //--------------------------------------------------------------------------------------------------
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    //--------------------------------------------------------------------------------------------------
    //MARK: - Actions
    
    @IBAction func onSegmentControl(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            loginButton.setTitle("Login", forState: .Normal)
        }
        else if sender.selectedSegmentIndex == 1 {
            loginButton.setTitle("Signup", forState: .Normal)

        }
    }
    
    
    
    
    
    @IBAction func onLoginButton(sender: UIButton) {
        
        guard let emailStr    = self.emailField.text else {print("No Email"); return}
        guard let passwordStr = self.passwordField.text else {print("No Password"); return}
        print("EMAIL:\(emailStr)   PASSWORD:\(passwordStr)")
        let paramsDictionary = ["email":emailStr, "password":passwordStr]
        
        
        if sender.titleLabel?.text == "Login" {
            print("Perform LOGIN")
            print("--URL:--  \(URL_LOGIN)")
            
            
            ////-LOGIN-//// POST /users/login
            API.post(URL_LOGIN, payload: paramsDictionary, userToken: nil, completed: { (response) in
                
                if response.success == true {
                    print("----------------------------------------------------------------------------------")
                    if let token = response.dataString {
                        print("token: \(token)")
                        
                        saveToken(token: token)
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    }
                    print("----------------------------------------------------------------------------------")
                }

            })
            ////-END OF LOGIN-////
            
        }
        else if sender.titleLabel?.text == "Signup"{
            print("Perform Signup")
            print("--URL:--  \(URL_SIGNUP)")
            
            
            ////-SIGNUP-//// POST /users
            API.post(URL_SIGNUP, payload: paramsDictionary, userToken: nil, completed: { (response) in
                
                print("----------------------------------------------------------------------------------")
                print(response)
                print("----------------------------------------------------------------------------------")
                
                
                if response.success == true {
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        let alert = UIAlertController(
                            title: "Success",
                            message: "Signed Up Succesfully",
                            preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                } else {
                    print("Shit No Response")
                }
            })
            ////-END OF SIGNUP-////
            
            
            
        }
    }
    




}
