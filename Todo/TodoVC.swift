//
//  ViewController.swift
//  Todo
//
//  Created by eugene golovanov on 7/14/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit

class TodoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    //--------------------------------------------------------------------------------------------------
    //MARK: - Properties

    var todos = [Todo]()
    
    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //--------------------------------------------------------------------------------------------------
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        

        if let token = NSUserDefaults.standardUserDefaults().stringForKey(KEY_TOKEN) {
            print("Token:\n\(token)")
            self.getAllTodosResponse()
        } else {
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
        
        

    }
    
    
    //--------------------------------------------------------------------------------------------------
    //MARK: - Responses
    
    func getAllTodosResponse() {
        spinner.startAnimating()

        
        ////GET /todos
        if let token = NSUserDefaults.standardUserDefaults().stringForKey(KEY_TOKEN) {
            API.get(URL_TODOS, userToken: token, completed: { (response) in
                
                
                if response.success == true {
                    
                    print("-------------RESPONSE----------------------")
                    if let data = response.dataArray {
                        
                        let allTodos = AllTodos(data: data)
                        self.todos = allTodos.todos
                        print(self.todos)
                        
                    }
                    print("------------------------------------------")
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        self.todoTableView.reloadData()
                        self.spinner.stopAnimating()
                    })
                    
                } else {
                    deleteToken()
                    self.spinner.stopAnimating()
                    self.performSegueWithIdentifier("loginSegue", sender: self)

                    let alert = UIAlertController(
                        title: "Failure",
                        message: "Response code:\(response.code)",
                        preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)

                }
            })
            
        }
        ////////////////////
    }
    
    
    
    
    func deleteTodo(id id:String) {
        print("DELETING ID: \(id)")
        
        //URL to edit
        let urlToDelete = URL_TODOS + "/\(id)"
        
        
        print("----------------------------------------------------------------------------------")
        print(urlToDelete)
        print("----------------------------------------------------------------------------------")

        self.spinner.startAnimating()
        
        
        
        //DELETE    /todos/:id
        if let token = NSUserDefaults.standardUserDefaults().stringForKey(KEY_TOKEN) {
            API.delete(urlToDelete, userToken: token, completed: { (response) in
                
                if response.success == true {
                    print("----------------------------------------------------------------------------------")
                    print(response)
                    print("----------------------------------------------------------------------------------")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.stopAnimating()
                        self.alert(title: "Success", message: "Todo Deleted")
                    })
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.stopAnimating()
                        self.alert(title: "Error Deleting todo", message: "Err:\(response.error)")
                    })
                }
                
            })
        }
        ///
        
        

    }

    
    
    //--------------------------------------------------------------------------------------------------
    //MARK: - Actions

    @IBAction func onLogoutButton(sender: UIButton) {
        
        
        print("----------------------------------------------------------------------------------")
        print("--URL:--  \(URL_LOGIN)")
        print("----------------------------------------------------------------------------------")
        
        self.spinner.startAnimating()

        
        
        //DELETE    /users/login
        if let token = NSUserDefaults.standardUserDefaults().stringForKey(KEY_TOKEN) {
            API.delete(URL_LOGIN, userToken: token, completed: { (response) in
                
                if response.success == true {
                    print("----------------------------------------------------------------------------------")
                    print(response)
                    print("----------------------------------------------------------------------------------")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.stopAnimating()
                        deleteToken()
                        self.performSegueWithIdentifier("loginSegue", sender: self)
//                        self.alert(title: "Success", message: "Logout")


                    })
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.stopAnimating()
                        self.alert(title: "Error Logout", message: "Err:\(response.error)")
                    })
                }
                
            })
        }
        ///

        
        
    }
    
    
    @IBAction func onGetAllTodos(sender: UIButton) {
        print("\nGetting All Todos")
        self.getAllTodosResponse()
    }
    
    @IBAction func onAddTodoAction(sender: UIButton) {
        self.performSegueWithIdentifier("addTodo", sender: self)
    }
    
    //--------------------------------------------------------------------------------------------------
    // MARK: - -Table View-
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ident", forIndexPath: indexPath)
        
        let todo = self.todos[indexPath.row]
//        cell.textLabel!.text = "id:\(todo.id)  \(todo.description)"
        cell.textLabel!.text = "\(todo.description)"

        cell.detailTextLabel!.text = todo.completed.description ?? "none"
        
        return cell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedTodo = self.todos[indexPath.row]
        print("Selected todo:\(selectedTodo)")
        performSegueWithIdentifier("editTodo", sender: selectedTodo)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.deleteTodo(id: self.todos[indexPath.row].id)
            self.todos.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

        }
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

    
    
    //--------------------------------------------------------------------------------------------------
    // MARK: - Segue

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editTodo" {
            guard let selectedTodo = sender as? Todo else {
                print("problem with selected todo")
                return
            }
            guard let destVC = segue.destinationViewController as? EditTodoVC else {
                print("problem with EditTodoVC")
                return
            }
            destVC.selectedTodo = selectedTodo
            
            
        }
    }


}

