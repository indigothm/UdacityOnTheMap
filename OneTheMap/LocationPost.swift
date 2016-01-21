//
//  LocationPost.swift
//  OneTheMap
//
//  Created by Ilia Tikhomirov on 10/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import Foundation
import MapKit

struct LocationPost {
    
    let firstname: String
    let lastname: String
    let mediaUrl: String
    let latitude: Double
    let longitude: Double
    
    var title: String? {
        return firstname + " " + lastname
    }
    
    var subtitle: String? {
        return mediaUrl
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
    init (dict: [String: AnyObject]) {
        
        self.firstname = dict["firstname"] as! String
        self.lastname = dict["lastname"] as! String
        self.mediaUrl = dict["mediaUrl"] as! String
        self.latitude = dict["latitude"] as! Double
        self.longitude = dict["longitude"] as! Double
        
    }
    
    
}