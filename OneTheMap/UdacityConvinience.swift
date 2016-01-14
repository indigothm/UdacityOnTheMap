//
//  UdacityConvinience.swift
//  OneTheMap
//
//  Created by Ilia Tikhomirov on 04/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import Foundation
import UIKit
//import Alamofire
//import SwiftyJSON
import SwiftSpinner

extension UdacityClient {
    
    class func getLocationsNative(completionHandler: ([LocationPost]) -> Void) -> Void {
    
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            if let JSONData = data {
                
                // Check 1
                if let json: AnyObject = try! NSJSONSerialization.JSONObjectWithData(JSONData, options: NSJSONReadingOptions.MutableContainers) {
                    
                    // Check 2
                    if let jsonDictionary = json as? NSDictionary {
                        
                        // Check 3
                        print("Dictionary received")
                        print(jsonDictionary)
                        
                        let dataArray = jsonDictionary["results"] as! NSArray
                        
                        var locationArray: [LocationPost] = []
                        
                        for subJson in dataArray  {
                            
                            let pinPoint: LocationPost = LocationPost(
                                
                                firstname: subJson["firstName"]! as! String,
                                lastname: subJson["lastName"]! as! String!,
                                mediaUrl: subJson["mediaURL"]! as! String!,
                            
                                latitude: subJson["latitude"]! as! Double,
                                longitude: subJson["longitude"] as! Double
                                
                            )
                            
                            
                            locationArray.append(pinPoint)
                            
                            
                        }
                        
                        print("LOCATIONS")
                        print(locationArray)
                        completionHandler(locationArray)
                        
                    }
                    else {
                        if let jsonString = NSString(data: JSONData, encoding: NSUTF8StringEncoding) {
                            print("JSON String: \n\n \(jsonString)")
                        }
                        fatalError("JSON does not contain a dictionary \(json)")
                    }
                }
                else {
                    fatalError("Can't parse JSON")
                }
            }
            else {
                fatalError("JSONData is nil")
            }
            
        }
        task.resume()
    
    }
    
    
    /*
    
    class func getLocations(completionHandler: ([LocationPost]) -> Void) -> Void {
        
        Alamofire.request(.GET, "https://api.parse.com/1/classes/StudentLocation", headers: ["X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"]).responseJSON(completionHandler: { (response) in
        
            print("TEST2")
            print(response)
            
            switch response.result {
            case .Success:
                
                if let value = response.result.value {
                    
                    
                        SwiftSpinner.hide()
                        let json = JSON(value)
                        print("JSON: \(json)")
                    
                        print(json["results"][1]["latitude"])
                    
                    var locationArray: [LocationPost] = []
                    
                    for (_, subJson) in json["results"] {
                        
                        let pinPoint: LocationPost = LocationPost(
                            
                            firstname: subJson["firstName"].string!,
                            lastname: subJson["lastName"].string!,
                            mediaUrl: subJson["mediaURL"].string!,
                            latitude: subJson["latitude"].double!,
                            longitude: subJson["longitude"].double!
                            
                        )
                        
                        locationArray.append(pinPoint)
                    
                        
                    }
                    
                    completionHandler(locationArray)
               
                    
                    
                }
                
            case .Failure(let error):
                print(error)
                SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
                
                
            }

            
        })
        
    }

*/
    
    class func postSessionNative(username: String, password: String, completionHandler: (Bool) -> Void) {
    
        SwiftSpinner.show("Authenticating...")
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Make JSON out of it
        let parameters: [ String : [String: AnyObject]] = [
            "udacity": [
                "username": username,
                "password": password
            ]
        ]
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
        
        request.HTTPBody = jsonData
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                
                print("ERROR PATH")
                SwiftSpinner.show("Error", animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
                
                return
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            let responseJSON = try! NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.MutableContainers) as? [String:AnyObject]
            
            print(responseJSON)

            if let _ = responseJSON?["status"] {
                
                print("Wrong credentials with status code")
                
            
                SwiftSpinner.show("Wrong credentials", animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
            
                
            }
            
            if let sesid = responseJSON?["session"]?["id"] {
                SwiftSpinner.hide()
                
                completionHandler(true)
                print(sesid)
                
                if let idNumber = responseJSON?["account"]?["key"]  {
                    
                    getPublicDataNative(idNumber as! String)
                    
                }
                
            } else {
                SwiftSpinner.show("Wrong credentials", animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
                
        }
        
        }
        task.resume()
        
    
    
    }
    
    /*
    
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
                                
                                if let idNumber = json["account"]["key"].string {
                                    
                                    getPublicData(idNumber)
                                    
                                }
                                
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

*/
    
  /*  class func getPublicData(key: String) {
        
        print("GETTING PUBLIC DATA")
    
        Alamofire.request(.GET, "https://www.udacity.com/api/users/" + key).response(completionHandler: { (response) in
            
            print("DISPLAYING")
            
            let data = response.2
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            
        
        })
        
    
    }

*/
    
    class func getPublicDataNative(key: String) {
    
        print("GETTING PUBLIC DATA")
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/" + key)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            
            let responseJSON = try! NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.MutableContainers) as? [String:AnyObject]
            
            print(responseJSON)
            
            print("data for the post func")
            
            print(responseJSON?["user"]!["key"]! as! String)
            print(responseJSON?["user"]!["last_name"]! as! String)
            print(responseJSON?["user"]!["nickname"]! as! String)
            
            UserLocation.firstname = responseJSON?["user"]!["nickname"]! as! String
            UserLocation.lastname = responseJSON?["user"]!["last_name"]! as! String
            UserLocation.lastname = responseJSON?["user"]!["key"]! as! String
            
            
            
        }
        task.resume()
        
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