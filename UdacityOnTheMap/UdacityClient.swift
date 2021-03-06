//
//  UdacityClient.swift
//  UdacityOnTheMap
//
//  Created by Sanket Ray on 17/07/17.
//  Copyright © 2017 Sanket Ray. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class UdacityClient: NSObject {
    
    class func attemptLogin( completionForLogin : @escaping (_ userID: String?, _ error: Error?, _ status: Int?)-> Void) {
   
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
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("wrong email id or password")
                
               completionForLogin(nil, nil, (response as? HTTPURLResponse)?.statusCode)
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
//            print("🍒",parsedResult,"🍒")
            
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
    class func logout (completion : @escaping (String)-> Void) {
        
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
            
        }
        task.resume()
        
        
        
    }
//GETing student locations
    
    class func getStudentLocations (completionForStudentLocations : @escaping (_ studentInfo: [[String:AnyObject]]?, _ status: Int?)->Void) {
        
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
            
            DispatchQueue.main.async{
                StudentInformationClass.sharedInstance.studentDetails = StudentInformation.studentsFromResults(results)
            }
            
            Data.studentData = results
            completionForStudentLocations(Data.studentData!,nil)
            
        }
        task.resume()
        
    }

//GETing My Details
    
    class func getMyDetails(userID : String){
        
        
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
    
    class func addMyOwnPin(completion : @escaping (_ error : Error?)->Void){
        
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
            completion(nil)
            
        }
        task.resume()
        
    }
    class func drawPins (arrayOfDictionaries: [[String:AnyObject]], completion: @escaping (_ annotaion: MKPointAnnotation?)-> Void) {
        
        for dictionary in arrayOfDictionaries {
            
            if let latitude = dictionary["latitude"]  {
                if let longitude = dictionary["longitude"]  {
                    let location = CLLocationCoordinate2DMake(latitude as! CLLocationDegrees, longitude as! CLLocationDegrees)
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate = location
                    guard let studentFirstName = dictionary["firstName"] else {
                        return
                    }
                    guard let studentLastName = dictionary["lastName"] else {
                        return
                    }
                    guard let studentURL = dictionary["mediaURL"] else {
                        return
                    }
                    annotation.title = "\(studentFirstName) \(studentLastName)"
                    annotation.subtitle = studentURL as? String
//                    map.addAnnotation(annotation)
                    completion(annotation)
                }
            }
        }
    }
}
