//
//  Login .swift
//  UdacityOnTheMap
//
//  Created by Sanket Ray on 13/07/17.
//  Copyright © 2017 Sanket Ray. All rights reserved.
//

import Foundation
import UIKit


func attemptLogin(completion : @escaping (String)-> Void) {
    

    
    let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = "{\"udacity\": {\"username\": \"\(loginEmail!)\", \"password\": \"\(loginPassword!)\"}}".data(using: String.Encoding.utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
        
        guard error == nil else {
            print("Check network Connection")
            
        /*The following code doesn't work...why????
           
             DispatchQueue.main.async {
                LoginViewController().alertView(title: "Network Error", message: "Please check you network connection")
            }
        */
            return
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            print("wrong email id or password")
          
            /*The following code doesn't work...why????
             
            DispatchQueue.main.async {
                LoginViewController().alertView(title: "Incorrect Credentials", message: "Please enter correct email id and password")
            }
          
           */
             return
        }
        
        guard let data = data else {
            print("error fetching data")
            return
        }
        
        
        
        let range = Range(5..<data.count)
        let newData = data.subdata(in: range) /* subset response data! */
        
        let parsedResult : [String:AnyObject]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
        }catch {
            print("error parsing data")
            return
        }
        
        
        print("🍒",parsedResult,"🍒")
        
        guard let session = parsedResult["session"] else {
            print("could not find session")
            return
        }
        
        guard let id = session["id"] as? String else {
            print("id not found")
            return
        }
        guard let account = parsedResult["account"] else {
            print("could not find account data")
            return
        }
        
        guard let key = account["key"] as? String else {
            print("uniqueKey not found")
            return
        }
        
        sessionID = id
        userID = key
        
        DispatchQueue.main.async{
        completion(userID!)
        }

      
        
        
    }
    task.resume()
    
    
    
}
