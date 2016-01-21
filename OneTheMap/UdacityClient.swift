//
//  UdacityClient.swift
//  OneTheMap
//
//  Created by Ilia Tikhomirov on 04/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import Foundation
import Alamofire
import MapKit

class UdacityClient: NSObject {

    class func openSafari(urlString: String, completionHandeler: (error: Bool) -> Void) {
        
        if urlString.rangeOfString("https://") == nil{
            
            print("adding https")
            
            let newS = "https://" + urlString
            
            if let exitUrl = NSURL(string: newS) {
            UIApplication.sharedApplication().openURL(exitUrl)
            } else {
                
                completionHandeler(error: true)
                
            }
            
        } else {
            
            if let exitUrl = NSURL(string: urlString) {
                
            UIApplication.sharedApplication().openURL(exitUrl)
            
            } else {
                
                completionHandeler(error: true)
                
            }
            
        }
        
    }    
    
}