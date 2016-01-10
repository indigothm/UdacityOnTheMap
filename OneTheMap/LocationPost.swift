//
//  LocationPost.swift
//  OneTheMap
//
//  Created by Ilia Tikhomirov on 10/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import Foundation

class LocationPost: NSObject {
    
    let firstname: String
    let lastname: String
    let mediaUrl: String
    let latitude: String
    let longitude: String
    
    init(firstname: String, lastname: String, mediaUrl: String, latitude: String, longitude: String) {
        
        self.firstname = firstname
        self.lastname = lastname
        self.mediaUrl = mediaUrl
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
}