//
//  ViewController.swift
//  Todo
//
//  Created by eugene golovanov on 7/14/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit

class TodoVC: UIViewController {

    
    var todos = [Todo]()
    
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
    
    
    @IBAction func onGetAllTodos(sender: UIButton) {
        print("\nGetting All Todos")
        
        ////GET Todos////
        if let token = NSUserDefaults.standardUserDefaults().stringForKey(KEY_TOKEN) {
            API.get(URL_TODOS, attachToken: true, alternateToken: token, completed: { (response) in
                if response.success == true {
                    
                    print("-------------RESPONSE----------------------")
                    if let data = response.dataArray {
                        
                        let allTodos = AllTodos(data: data)
                        self.todos = allTodos.todos
                        print(self.todos)
                    
                    }
                    print("------------------------------------------")
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        let alert = UIAlertController(
                            title: "Got All TODOS",
                            message: "I Have All TODOS",
                            preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    })

                }
            })

        }
        ////////////////////
        
        
        
    }

}

