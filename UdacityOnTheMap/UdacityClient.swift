//
//  UdacityClient.swift
//  UdacityOnTheMap
//
//  Created by Sanket Ray on 17/07/17.
//  Copyright © 2017 Sanket Ray. All rights reserved.
//

import UIKit

class UdacityClient: NSObject {

 
    
//LOGIN
    
    func attemptLogin( completionForLogin : @escaping (_ userID: String?, _ error: Error?, _ status: Int?)-> Void) {
   
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(loginEmail!)\", \"password\": \"\(loginPassword!)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard error == nil else {
                print("Check network Connection")
                
                
                completionForLogin(nil, error, nil)
                /*The following code doesn't work...why????
                 
                 DispatchQueue.main.async {
                 LoginViewController().alertView(title: "Network Error", message: "Please check you network connection")
                 }
                 */


                
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("wrong email id or password")
                
               completionForLogin(nil, nil, (response as? HTTPURLResponse)?.statusCode)
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
                completionForLogin(userID!, nil, nil)
            }
            
            
            
            
        }
        task.resume()
        
        
        
    }
//LOGOUT
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
            print("🍛",logoutSessionID!,"🍛")
            
            
        }
        task.resume()
        
        
        
    }
//GETing student locations
    
    func getStudentLocations (completionForStudentLocations : @escaping (_ studentInfo: [[String:AnyObject]]?, _ status: Int?)->Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard error == nil else {
                print("error while requesting data")
                
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Status Code was other than 2xx🍋")
                
                completionForStudentLocations(nil,(response as? HTTPURLResponse)?.statusCode)
                /*
                 DispatchQueue.main.async {
                 LoginViewController().alertView(title: "Download Failed", message: "Something Went Wrong!")
                 }
                 */
                
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
            
            guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                print("error processing parsed Result")
                return
            }
            //result is of the type [[String:Any]]
            print(results)
            
            StudentInformationClass.sharedInstance.studentDetails = StudentInformation.studentsFromResults(results)
            
           //saving data to "Student Information Structure and I don't feel like using it right now"
          //self.students = StudentInformation.studentsFromResults(results)
         //self.users?.studentsLocationData = StudentInformation.studentsFromResults(results)
            
            print("🥗🍇🍉",results.count,"🍇🥗🍉")
            
       //      print("🏓🍟🥒🌶🍚",self.students,"🏓🍟🥒🌶🍚")
      //      print(self.students.count,"🍶🍶🍶🍶🍶🍶🍶🍶🍶")
            
            //🍇 updating student Data...Uncomment the line below
            studentData = results
            
            
           
            
            completionForStudentLocations(studentData!,nil)
            
        }
        task.resume()
        
    }

//GETing My Details
    
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

 //Add My Pin on the Map
    
    func addMyOwnPin(completion : @escaping (_ error : Error?)->Void){
        
        
        
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
                
                completion(error)
                
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Status Code was other than 2xx")
                
               // completion((response as? HTTPURLResponse)?.statusCode)
                /*
                 DispatchQueue.main.async {
                 LoginViewController().alertView(title: "Request Failed", message: nil)
                 }
                 */
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
            
            completion(nil)
            
        }
        task.resume()
        
        
        
        
    }

    

}
