//
//  Student Information.swift
//  UdacityOnTheMap
//
//  Created by Sanket Ray on 17/07/17.
//  Copyright © 2017 Sanket Ray. All rights reserved.
//

import Foundation
import MapKit


struct StudentInformation {
    var latitude: CLLocationDegrees?
    var mapString: String?
    var createdAt: String?
    var uniqueKey: String?
    var objectId: String?
    var updatedAt: String?
    var firstName: String?
    var longitude: CLLocationDegrees?
    var mediaURL: String?
    var lastName: String?
    
  // i will add a dictionary as the argument.
    
    init(studentInformation : [String:AnyObject])
    {
        latitude = studentInformation["latitude"] as? CLLocationDegrees
        mapString = studentInformation["mapString"] as? String
        createdAt = studentInformation["createdAt"] as? String
        uniqueKey = studentInformation["uniqueKey"] as? String
        objectId = studentInformation["objectId"] as? String
        updatedAt = studentInformation["updatedAt"] as? String
        firstName = studentInformation["firstName"] as? String
        longitude = studentInformation["longitude"] as? CLLocationDegrees
        mediaURL = studentInformation["mediaURL"] as? String
        lastName = studentInformation["lastName"] as? String
    }
 
    
    static func studentsFromResults(_ allStudents: [[String:AnyObject]])->[StudentInformation] {
        
        var students = [StudentInformation]()
        
        //iterate through array of dictionaries, each student is a dictionary
        
        for oneStudent in allStudents {
            students.append(StudentInformation(studentInformation:oneStudent))
        }
        
        return students
    }
    
    
    
    
    
    
}
