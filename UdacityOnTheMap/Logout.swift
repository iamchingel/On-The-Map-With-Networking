//
//  Logout.swift
//  UdacityOnTheMap
//
//  Created by Sanket Ray on 15/07/17.
//  Copyright © 2017 Sanket Ray. All rights reserved.
//

import Foundation

func logout (completion : @escaping (String)-> Void) {
    
    let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    request.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies! {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
        request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
        
        
        guard error == nil else {
            print("error processing request")
            return
        }
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            print("status code was other than 2xx")
            return
        }
        guard let data = data else {
            print("error getting data from server")
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
        
        guard let logoutSession = parsedResult["session"] else {
            print("couldn't get logout session")
            return
        }
        
        guard let logoutSessionID = logoutSession["id"] else {
            print("couldn't get logout session ID")
            return
        }
        
          completion(logoutSessionID! as! String)
        print("🍛",logoutSessionID,"🍛")
      
        
    }
    task.resume()
    
  
    
}
