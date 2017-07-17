//
//  Student Information.swift
//  UdacityOnTheMap
//
//  Created by Sanket Ray on 17/07/17.
//  Copyright © 2017 Sanket Ray. All rights reserved.
//

import Foundation

struct StudentInformation {
    var latitude: Double
    var mapString: String
    var createdAt: String
    var uniqueKey: Int
    var objectId: String
    var updatedAt: String
    var firstName: String
    var longitude: Double
    var mediaURL: String
    var lastName: String
    
  // i will add a dictionary as the argument.
    
    init(latitude: Double, mapString: String, createdAt: String, uniqueKey: Int, objectId: String, updatedAt: String, firstName: String, longitude: Double, mediaURL: String, lastName: String)
    {
        self.latitude = latitude
        self.mapString = mapString
        self.createdAt = createdAt
        self.uniqueKey = uniqueKey
        self.objectId = objectId
        self.updatedAt = updatedAt
        self.firstName = firstName
        self.longitude = longitude
        self.mediaURL = mediaURL
        self.lastName = lastName
    }
}
