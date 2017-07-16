//
//  PostMyPin.swift
//  UdacityOnTheMap
//
//  Created by Sanket Ray on 15/07/17.
//  Copyright © 2017 Sanket Ray. All rights reserved.
//

import Foundation

func addMyOwnPin(completion : ()->Void){
    
  
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(userID!)\", \"firstName\": \"\(firstName!)\", \"lastName\": \"\(lastName!)\",\"mapString\": \"\(myLocation!)\", \"mediaURL\": \"\(myURL!)\",\"latitude\": \(locationLatitude!), \"longitude\": \(locationLongitude!)}".data(using: String.Encoding.utf8)
        
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard error == nil else {
                print("error while requesting data")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Status Code was other than 2xx")
                
                return
            }
            guard let data = data else {
                print("request for data failed")
                return
            }
            //parsing data : List of all students with their details
            let parsedResult : [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            }catch {
                print("error parsing data")
                return
            }
            
            
            print("🍏",parsedResult,"🍏")
            
            
            
        }
        task.resume()
    
        completion()
    
     
}
