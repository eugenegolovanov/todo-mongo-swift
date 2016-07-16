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
//            print("\(sender.selectedSegmentIndex)")
        
        if sender.selectedSegmentIndex == 0 {
            loginButton.setTitle("Login", forState: .Normal)
        }
        else if sender.selectedSegmentIndex == 1 {
            loginButton.setTitle("Signup", forState: .Normal)

        }
        
        
    }
    
    @IBAction func onLoginButton(sender: UIButton) {
        
        let api = "https://egtodo.herokuapp.com"
//        let api = "https://localhost:3000"

        let todos = "/todos"
        let login = "/users/login"
        let signup = "/users"
        
        var url = api


        
        let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbiI6IlUyRnNkR1ZrWDE5YmxrOVN6b1NENHQ2azJxd3Jqc29LMFIydG1GQ0tDNFFKVlN0d0VXeDFQUmZFM2xVRTdJVXMxcTdSc3ZWM0VuNlhKQ0JXYjdxRFhRPT0iLCJpYXQiOjE0Njg2MjYxMTh9.2cf2Np-b28630XRp_WPYFwsqor6_bG4gDyd4anTz5Mg"
        
        
        guard let emailStr    = self.emailField.text else {print("No Email"); return}
        guard let passwordStr = self.passwordField.text else {print("No Password"); return}
        print("EMAIL:\(emailStr)   PASSWORD:\(passwordStr)")
        let paramsDictionary = ["email":emailStr, "password":passwordStr]
        
        
        
        
        if sender.titleLabel?.text == "Login" {
            print("Perform LOGIN")
            url = api + login
            print("--URL:--  \(url)")
            
            
            //-LOGIN-//
            API.post(url, payload: paramsDictionary, attachToken: false, alternateToken: nil, completed: { (response) in
                
                print("----------------------------------------------------------------------------------")
                if let token = response.dataString {
                    print("token: \(token)")
                }
                print("----------------------------------------------------------------------------------")

            })
            //-END OF LOGIN-//
        
            
            
            
            
            
            
            
        }
        else if sender.titleLabel?.text == "Signup"{
            print("Perform Signup")
            url = api + signup
            print("--URL:--  \(url)")
            
            
            
            
            //-SIGNUP-//
            API.post(url, payload: paramsDictionary, attachToken: false, alternateToken: nil, completed: { (response) in
                
                print("----------------------------------------------------------------------------------")
                print(response)
                print("----------------------------------------------------------------------------------")
                
            })
            //-END OF SIGNUP-//
            
            
            
        }
    }
    
    
    
    
    
    
    
    //--------------------------------------------------------------------------------------------------
    //MARK: - API
    
    
    
    
    
    func postLoginRequest(params:Dictionary<String, String>, completion: (data: NSData?, response:NSURLResponse?, error:NSError?) -> Void) {
        let urlPath: String = "https://egtodo.herokuapp.com/users/login"
        let url = NSURL(string: urlPath)
        let request = NSMutableURLRequest(URL: url!);
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let session = NSURLSession.sharedSession()
        
        // Verify downloading data is allowed
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
        } catch let error as NSError {
            print("Error in request post: \(error)")
            request.HTTPBody = nil
        } catch {
            print("Catch all error: \(error)")
        }
        
        
        
        // Post the data
        let task = session.dataTaskWithRequest(request) { data, response, error in
            completion(data: data, response: response, error: error)
        }
        
        task.resume()
        
    }

    
    
    
    
    func getAllTodos(token token:String, completion: (data: NSData?, response:NSURLResponse?, error:NSError?) -> Void) {
        
        let urlPath: String = "https://egtodo.herokuapp.com/todos"
        let url = NSURL(string: urlPath)
        let request = NSMutableURLRequest(URL: url!);
        //Token
        request.addValue(token, forHTTPHeaderField: "Auth")
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            //in case of error
            if error != nil {
                print("shit err")
                completion(data: data, response: response, error: error)

                return
            } else {
                guard let data = data else {print("error getting data"); return}
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    print("JSON:\(json)")
                    
                    completion(data: data, response: response, error: error)
                    
                    
//                    //If NOT Array
//                    if let desc = json["description"] as? String {
//                        print("JSON is NOT Array")
//                        print("DESCRIPT: \(desc)")
//                    }
//                    
//                    //If ARRAY
//                    if let todoArray = json as? [AnyObject] {
//                        print("JSON is ARRAY")
//                        
//                        for todo in todoArray  {
//                            if let desc = todo["description"] as? String,
//                                let id = todo["id"] as? Int {
//                                print("-----------------------------------")
//                                print("id:\(id)  DESCRIPT: \(desc)")
//                            }
//                        }
//                    }
                    
                    
                    
                    
                } catch {
                    print("ERROR:\(error)")
                }
            }
        }
        task.resume();
    }

    
    
    
    
 



}
