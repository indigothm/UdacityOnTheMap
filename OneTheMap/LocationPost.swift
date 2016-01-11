//
//  LocationPost.swift
//  OneTheMap
//
//  Created by Ilia Tikhomirov on 10/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import Foundation
import MapKit

class LocationPost: NSObject, MKAnnotation {
    
    let firstname: String
    let lastname: String
    let mediaUrl: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(firstname: String, lastname: String, mediaUrl: String, latitude: Double, longitude: Double) {
        
        self.firstname = firstname
        self.lastname = lastname
        self.mediaUrl = mediaUrl
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    
}