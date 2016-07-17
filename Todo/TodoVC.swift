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
            performSegueWithIdentifier("loginSegue", sender: self)
        }
        
        

    }
    
    
    //--------------------------------------------------------------------------------------------------
    //MARK: - Responses
    
    func getAllTodosResponse() {
        spinner.startAnimating()

        
        ////GET /todos
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
//                        let alert = UIAlertController(
//                            title: "Got All TODOS",
//                            message: "I Have All TODOS",
//                            preferredStyle: .Alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//                        self.presentViewController(alert, animated: true, completion: nil)
                        
                        self.todoTableView.reloadData()
                        self.spinner.stopAnimating()
                    })
                    
                } else {
                    self.spinner.stopAnimating()
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

    
    
    //--------------------------------------------------------------------------------------------------
    //MARK: - Actions

    @IBAction func onLogoutButton(sender: UIButton) {
        deleteToken()
        performSegueWithIdentifier("loginSegue", sender: self)
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
        cell.textLabel!.text = "id:\(todo.id)  \(todo.description)"
        cell.detailTextLabel!.text = todo.completed.description ?? "none"
        
        return cell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedTodo = self.todos[indexPath.row]
        print("Selected todo:\(selectedTodo)")
        performSegueWithIdentifier("editTodo", sender: selectedTodo)
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

