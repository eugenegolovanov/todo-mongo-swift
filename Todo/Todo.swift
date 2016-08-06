//
//  User.swift
//  Todo
//
//  Created by eugene golovanov on 7/15/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import Foundation


class AllTodos: CustomDebugStringConvertible {
    var data:Array<Dictionary<String, AnyObject>>
    var todos = [Todo]()
    
    init(data:Array<Dictionary<String, AnyObject>>) {
        self.data = data
        
        for d in data {
            let todo = Todo(data: d)
            self.todos.append(todo)
        }
    }
    
    var debugDescription: String {
        return ""
    }
}





class Todo: CustomDebugStringConvertible {
    
    var data:[String:AnyObject]
//    var id = Int()
    var id:String = ""
    var description:String = ""
    var completed = false
    var priority = 0
    
    init(data:[String:AnyObject]) {
        self.data = data
//        self.id = (self.data["id"] as? Int ?? 0)
        self.id = (self.data["_id"] as? String ?? "")
        self.description = (self.data["description"] as? String ?? "")
        self.completed = (self.data["completed"] as? Bool ?? false)
        
//        let compl = (self.data["completed"] as? NSString ?? "")
//        self.completed = NSString(string:compl).boolValue

    }
    
    var debugDescription: String {
        return "<Description: \(self.description), completed:\(self.completed)>"
    }

}

