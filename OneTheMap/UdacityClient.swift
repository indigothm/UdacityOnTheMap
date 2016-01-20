//
//  UdacityClient.swift
//  OneTheMap
//
//  Created by Ilia Tikhomirov on 04/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import Foundation
import Alamofire

class UdacityClient: NSObject {

    class func openSafari(urlString: String) {
        
        if urlString.rangeOfString("https://") == nil{
            
            print("adding https")
            
            let newS = "https://" + urlString
            
            var exitUrl : NSURL
            exitUrl = NSURL(string: newS)!
            UIApplication.sharedApplication().openURL(exitUrl)
            
        } else {
            
            var exitUrl : NSURL
            exitUrl = NSURL(string: urlString)!
            UIApplication.sharedApplication().openURL(exitUrl)
            
        }
        
    }    
    
}