//
//  MyUdacityDetails.swift
//  UdacityOnTheMap
//
//  Created by Sanket Ray on 15/07/17.
//  Copyright © 2017 Sanket Ray. All rights reserved.
//

import Foundation


func getMyDetails(userID : String){
   
    
    let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userID)")!)
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
        
        guard error == nil else {
            print("error processing request")
            return
        }
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            print("status code other than 2xx")
            return
        }
        guard let data = data else {
            print("error getting data")
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
        
        let user = parsedResult["user"]
        
        guard let fName = user?["first_name"] as? String else {
            print("error getting first name")
            return
        }
        guard let lName = user?["last_name"] as? String else {
            print("error getting last name")
            return
        }
        
        firstName = fName
        lastName = lName
        
    }
    task.resume()
    
    
}
