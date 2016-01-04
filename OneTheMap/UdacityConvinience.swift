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

extension UdacityClient {
    
   class func postSession(username: String, password: String) {
        
    let parameters: [ String : [String: AnyObject]] = [
            "udacity": [
            "username": username,
            "password": password
            ]
        ]
    
    print("works")
        
    Alamofire.request(.POST, "https://www.udacity.com/api/session", parameters: parameters, encoding: .JSON).responseString(completionHandler: { response in
        
            print(response.result)

            switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        
                        var data = value as String!
                        let range = NSMakeRange(0,5)
                        data.deleteCharactersInRange(range)
                        
                        let json = JSON(data)
                        print("JSON: \(json)")
                        
                        //COMPLETE OPERATIONS WITH JSON

                      
                
                }
                
                case .Failure(let error):
                    print(error)
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