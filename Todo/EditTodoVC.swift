//
//  EditTodoVC.swift
//  Todo
//
//  Created by eugene golovanov on 7/17/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit

class EditTodoVC: UIViewController, UITextFieldDelegate {

    //--------------------------------------------------------------------------------------------------
    //MARK: - Properties
    
    @IBOutlet weak var completedSegmentCntrl: UISegmentedControl!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var selectedTodo:Todo?
    
    //--------------------------------------------------------------------------------------------------
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionField.delegate = self
        
        
        //SETTING Existing Todo Values
        guard let selTodo = self.selectedTodo else {
            print("broblem with init selected todo")
            return
        }
        self.descriptionField.text = selTodo.description
        if selTodo.completed == true {
            self.completedSegmentCntrl.selectedSegmentIndex = 1
        } else {
            self.completedSegmentCntrl.selectedSegmentIndex = 0
        }
        
    }
    
    
    //--------------------------------------------------------------------------------------------------
    //MARK: - Actions
    
    @IBAction func onPutTodoAction(sender: UIButton) {
        
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
        
        //id
        guard let selTodo = self.selectedTodo else {print("no id");return}
        let id = selTodo.id
        
        //URL to edit
        let urlToPut = URL_TODOS + "/\(id)"
        
        
        if descriptionString != "" {
            
            
            print("----------------------------------------------------------------------------------")
            print(descriptionString)
            print(completed)
            print(urlToPut)
            print("----------------------------------------------------------------------------------")
            
            
            
            
            let paramsDictionary = ["description":descriptionString, "completed":completed.description ?? "none"]
            self.spinner.startAnimating()
            
            //PUT /todos/:id
            if let token = NSUserDefaults.standardUserDefaults().stringForKey(KEY_TOKEN) {
                API.put(urlToPut, payload: paramsDictionary, attachToken: true, alternateToken: token, completed: { (response) in
                    
                    if response.success == true {
                        print("----------------------------------------------------------------------------------")
                        print(response)
                        print("----------------------------------------------------------------------------------")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinner.stopAnimating()
                            self.descriptionField.text = ""
                            self.alert(title: "Success", message: "Todo Updated")
                        })
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinner.stopAnimating()
                            self.alert(title: "Error updating todo", message: "Err:\(response.error)")
                        })
                    }
                    
                })
            }
            ///
            
            
            
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
