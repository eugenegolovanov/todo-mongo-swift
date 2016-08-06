//
//  Constants.swift
//  Todo
//
//  Created by eugene golovanov on 7/16/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import Foundation


//let URL_API = "https://egtodo.herokuapp.com"
//let URL_API = "https://localhost:3000"//HOME
let URL_API = "http://192.168.0.2:3000"//HOME
//let URL_API = "http://192.168.10.234:3000"//WORK


let URL_TODOS = URL_API + "/todos"
let URL_LOGIN = URL_API + "/users/login"
let URL_SIGNUP = URL_API + "/users"





//--------------TOKEN-------------------//

let KEY_TOKEN = "Auth"

//Token Save
func saveToken(token token:String) {
    //Save Token
    NSUserDefaults.standardUserDefaults().setObject(token, forKey: KEY_TOKEN)
    print("\nToken SAVED")
}

//Token Delete
func deleteToken() {
    //Save Token
    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: KEY_TOKEN)
    print("\nToken DELETED")
    
}
