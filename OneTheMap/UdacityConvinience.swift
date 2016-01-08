//
//  UdacityConvinience.swift
//  OneTheMap
//
//  Created by Ilia Tikhomirov on 04/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

extension UdacityClient {
    
    class func postSession(username: String, password: String, completionHandler: (Bool) -> Void) {
        
    SwiftSpinner.show("Authenticating...")
            
    let parameters: [ String : [String: AnyObject]] = [
            "udacity": [
            "username": username,
            "password": password
            ]
        ]
    
    print("works")
        
    Alamofire.request(.POST, "https://www.udacity.com/api/session", parameters: parameters, encoding: .JSON).responseString(completionHandler: { (response) in
        
        
            print(response.result)

            switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        
                        var data = value as String!
                        let range = NSMakeRange(0,5)
                        data.deleteCharactersInRange(range)
                        
                        if let dataFromString = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                            let json = JSON(data: dataFromString)
                            
                            print("JSON: \(json)")
                            print(json["session"]["id"])
                            
                            if let _ = json["session"]["id"].string {
                            SwiftSpinner.hide()
                            completionHandler(true)
                            } else {
                                SwiftSpinner.show("Wrong credentials", animated: false).addTapHandler({
                                    SwiftSpinner.hide()
                                })

                            }
        
                        }
                
                }
                
                case .Failure(let error):
                    print(error)
                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                        SwiftSpinner.hide()
                    })
                
                
        }
        
        })
    

    
    
    }
    

}


extension String {
    mutating func deleteCharactersInRange(range: NSRange) {
        
        let length = range.length
        let startIndex = self.startIndex
        let endIndex = self.startIndex.advancedBy(length)
    self.removeRange(Range<String.Index>(start: startIndex, end: endIndex))
        
    }
}