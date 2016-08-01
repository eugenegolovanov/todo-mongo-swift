//
//  AddTodoVC.swift
//  Todo
//
//  Created by eugene golovanov on 7/16/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit

class AddTodoVC: UIViewController, UITextFieldDelegate {

    
    //--------------------------------------------------------------------------------------------------
    //MARK: - Properties

    @IBOutlet weak var completedSegmentCntrl: UISegmentedControl!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    //--------------------------------------------------------------------------------------------------
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionField.delegate = self
    }

    
    //--------------------------------------------------------------------------------------------------
    //MARK: - Actions

    @IBAction func onPostTodoAction(sender: UIButton) {
        
        var descriptionString = ""
        var completed = false
        
        //Description
        if self.descriptionField.text != "" {
            if let desc = self.descriptionField.text  {
                descriptionString = desc
            }
        } else {
            self.alert(title: "Message is empty", message: "Enter Something")
        }
        
        //Completed
        if self.completedSegmentCntrl.selectedSegmentIndex == 1 {
            completed = true
        } else {
            completed = false
        }
        
        
        if descriptionString != "" {
            
            
            print("----------------------------------------------------------------------------------")
            print(descriptionString)
            print(completed)
            print("----------------------------------------------------------------------------------")
            
            let paramsDictionary = ["description":descriptionString, "completed":completed.description ?? "none"]
            self.spinner.startAnimating()
            
            //POST /todos
            if let token = NSUserDefaults.standardUserDefaults().stringForKey(KEY_TOKEN) {
                API.post(URL_TODOS, payload: paramsDictionary, userToken: token, completed: { (response) in

                    if response.success == true {
                        print("----------------------------------------------------------------------------------")
                        print(response)
                        print("----------------------------------------------------------------------------------")
                        dispatch_async(dispatch_get_main_queue(), { 
                            self.spinner.stopAnimating()
                            self.descriptionField.text = ""
                            self.alert(title: "Success", message: "Todo Posted")
                        })
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.alert(title: "Error posting todo", message: "Err:\(response.error)")
                        })
                    }
                    
                })
            }
            /////

            
            
        }
        
    }

    
    //--------------------------------------------------------------------------------------------------
    //MARK: - -UITextFieldDelegate-
    
    //Dismiss keyboard
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)    {
        self.view.endEditing(true)
    }
    

    
    
    //--------------------------------------------------------------------------------------------------
    //MARK: - Helper

    
    func alert(title title:String, message:String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    
    
}
