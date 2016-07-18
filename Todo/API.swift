//
//  API.swift
//  Todo
//
//  Created by eugene golovanov on 7/14/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import Foundation

enum ResponseType:ErrorType{
    case Success
    case ServerError
    case ValidationError
    case Unauthorized
    case PreconditionFail
    case UndefinedResponse
}



public class APIResponse: CustomDebugStringConvertible {
    public var code:Int
    public var success:Bool
    public var rawData:AnyObject?
    public var data:Dictionary<String,AnyObject>?
    public var dataArray:Array<Dictionary<String, AnyObject>>?
    public var multiDataArray:Array<Array<Dictionary<String, AnyObject>>>?
    public var dataNum:Int?
    public var dataString:String?
    public var error:NSError?
    public let request:NSURLRequest?
    public let duration:NSTimeInterval
    
    init(request:NSURLRequest?, duration:NSTimeInterval, payload:AnyObject?, error:NSError?){
        self.code = -1
        self.success = false
        self.data = nil
        self.error = nil
        self.request = request
        self.duration = duration
        
        if(error != nil){
            self.error = error
        }
        else if let obj = payload {
            self.rawData = obj
            if let dict = obj as? Dictionary<String,AnyObject>,
                code = dict["code"] as? Int,
                success = dict["success"] as? Bool {
                
                self.success = success
                self.code = code
                
                if let data = dict["data"] as? Dictionary<String, AnyObject> {
                    self.data = data
                } else if let data = dict["data"] as? Array<Dictionary<String, AnyObject>> {
                    self.dataArray = data
                } else if let data = dict["data"] as? Array<Array<Dictionary<String, AnyObject>>> {
                    self.multiDataArray = data
                } else if let data = dict["data"] as? String {
                    self.dataString = data
                } else if let data = dict["data"] as? [Int] {
                    if data.count > 0{
                        self.dataNum = data[0]
                    }
                }
            }
        }
        
//        print(self.debugDescription)
        if self.success == false {
//            print(self.request!.cURL())
        }
    }
    
    public var debugDescription: String {
        var descr = "<APIResponse"
        
        if let r = self.request, u = r.URL, m = r.HTTPMethod {
            descr += " \(m) \(u)"
        }
        
        descr += " success=\(self.success) code=\(self.code)"
        
        if let err = self.error {
            descr += " error=\(err)"
        }
        
//        if let r = self.request, t = r.valueForHTTPHeaderField("Auth") {
//            descr += " token=\(t)"
//        }
        
        let d = NSString(format: "%.2f", self.duration)
        return descr + " duration=\(d)s>"
    }
}





public class API {
    
//    static let manager:Manager = {
//        let serverTrustPolicies: [String: ServerTrustPolicy] = [
//            "prov-stg.hart.com": .PinCertificates(
//                certificates: ServerTrustPolicy.certificatesInBundle(),
//                validateCertificateChain: true,
//                validateHost: true
//            )
//        ]
//        print("Found certs in bundle: \(ServerTrustPolicy.certificatesInBundle())")
//        return Manager(serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
//    }()
    
    
    
    
    
    
    //Get
    public class func get(url:AnyObject, attachToken:Bool = true, alternateToken:String? = nil, completed: (response:APIResponse) -> Void) {
        self.createURLRequest(url, method: "GET", attachToken: attachToken, alternateToken: alternateToken, content: nil, completed: completed)
    }
    
    //Post
    public class func post(url:AnyObject, payload:[String:AnyObject]? = nil, attachToken:Bool = true, alternateToken:String? = nil, completed: (response:APIResponse) -> Void) {
        self.createURLRequest(url, method: "POST", attachToken: attachToken, alternateToken: alternateToken, content: payload, completed: completed)
    }
    
    //Put
    public class func put(url:AnyObject, payload:[String:AnyObject]? = nil, attachToken:Bool = true, alternateToken:String? = nil, completed: (response:APIResponse) -> Void) {
        self.createURLRequest(url, method: "PUT", attachToken: attachToken, alternateToken: alternateToken, content: payload, completed: completed)
    }
    
    //Delete
    public class func delete(url:AnyObject, attachToken:Bool = true, alternateToken:String? = nil, completed: (response:APIResponse) -> Void) {
        self.createURLRequest(url, method: "DELETE", attachToken: attachToken, alternateToken: alternateToken, content: nil, completed: completed)
    }
    
    
    
    
    
    
    
    
    
    private class func createURLRequest(u:AnyObject, method:String, attachToken:Bool, alternateToken:String? = nil, content:[String:AnyObject]? = nil, completed: (response:APIResponse) -> Void) -> Void {
        
        let startTime = NSDate()
        
        
//        let sendResponse: (NSURLRequest?, AnyObject?, NSError?) -> Void = { (request, data, error) -> Void in
//            dispatch_async(dispatch_get_main_queue(),{
//                completed(response: APIResponse(request: request, duration: NSDate().timeIntervalSinceDate(startTime), payload: data, error: error))
//            })
//        }
        
        let url:NSURL
        
        if let ur = u as? NSURL {
            url = ur
        } else if let ur = u as? String, uu = NSURL(string: ur) {
            url = uu
        } else {
            completed(response: APIResponse(request: nil, duration: 0, payload: nil, error: nil))
            return
        }
        let request = NSMutableURLRequest(URL: url)
        
        
        //If Token
        if attachToken == true {
            guard let token = alternateToken else {
                print("Token Problem")
                return
            }
            print("\nAPI \(method) \(url) with token \(token)")
            request.addValue(token, forHTTPHeaderField: "Auth")
        }
        

        
        
        

		request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
		request.HTTPMethod = method
		
		let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
		sessionConfig.timeoutIntervalForRequest = 30

        //POST PUT
        if method == "POST" || method == "PUT" {
            if let params = content {
                
                do {
                    request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
                } catch let error as NSError {
                    print("Error in request post: \(error)")
                    request.HTTPBody = nil
                } catch {
                    print("Catch all error: \(error)")
                }
            }
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                (data:NSData?, response:NSURLResponse?, error:NSError?) in
                
                guard let httpResponse = response as? NSHTTPURLResponse else{print("No post Response"); return}
                //OBJ fo response
                var obj = Dictionary<String,AnyObject>()
                obj["code"] = httpResponse.statusCode
                obj["success"] = API.statusSuccessChecker(httpResponse.statusCode)
                
                //Token If exists
                if let token = httpResponse.allHeaderFields["Auth"] {
                    obj["data"] = token as? String
                }

                completed(response: APIResponse(request: request, duration: NSDate().timeIntervalSinceDate(startTime), payload: obj, error: error))
            }

            task.resume()

        }
        //GET
        else if method == "GET" {
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                (data:NSData?, response:NSURLResponse?, error:NSError?) in
                
                
                guard let httpResponse = response as? NSHTTPURLResponse else{print("No get Response"); return}
                //OBJ fo response
                var obj = Dictionary<String,AnyObject>()
                obj["code"] = httpResponse.statusCode
                obj["success"] = API.statusSuccessChecker(httpResponse.statusCode)

                //in case of error
                if error != nil {
                    print("shit err")
                    completed(response: APIResponse(request: request, duration: NSDate().timeIntervalSinceDate(startTime), payload: data, error: error))

                    return
                } else {
                    guard let data = data else {print("error getting data"); return}
                    
                    do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                            print("\nJSON:\(json)")
                            
                            //If ARRAY
                            if let todoArray = json as? [AnyObject] {
                                obj["data"] = todoArray
                            }
                                //If DICT
                            else {
                                obj = json as! Dictionary<String, AnyObject>
                            }
                        
                        completed(response: APIResponse(request: request, duration: NSDate().timeIntervalSinceDate(startTime), payload: obj, error: error))
                        
                    } catch {
                        print("ERROR:\(error)")
                        completed(response: APIResponse(request: request, duration: NSDate().timeIntervalSinceDate(startTime), payload: obj, error: nil))

                    }
                }
            

            }
            task.resume()

        }
            
            
        
    }
    
    
    
    
    
    
    
    
    public class func statusSuccessChecker(code:Int) -> Bool {
        var success = false
        
             if code == 200 {
                print("SUCCESS.........200")
                success = true
             }
        else if code == 201 {
                print("SUCCESS.........201")
                success = true
             }
        
        else if code == 500 {
                print("SERVER ERROR.........500")
             }
        
        else if code == 400 {
                print("VALIDATION ERROR.........400")
             }
        
        else if code == 401 {
                print("UNAUTHORIZED ERROR.........401")
             }
        
        else if code == 412 {
                print("PRECONDITIONAL FAIL ERROR.........412")
             }
        
        else  {
                print("UNDEFINED RESPONSE")
        }
    
        return success
    }


    


}
