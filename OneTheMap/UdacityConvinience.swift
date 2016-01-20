//
//  UdacityConvinience.swift
//  OneTheMap
//
//  Created by Ilia Tikhomirov on 04/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner

extension UdacityClient {
    
    
    class func postLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: AnyObject, longitude: AnyObject, completionHandler: (Bool) -> Void) -> Void {
        
        let parameters: [ String : AnyObject] = [
            
                "uniqueKey": uniqueKey,
                "firstName": firstName,
                "lastName": lastName,
                "mapString": mapString,
                "mediaURL": mediaURL,
                "latitude": latitude,
                "longitude": longitude
        ]
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonData
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                
                
                
                
                return
            }
            
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        
            print("SUCCESS")
            
            completionHandler(true)

        }
        task.resume()
        
    }
    
    class func logOut() -> Void {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
    }
    
    class func getLocationsNative(completionHandler: ([LocationPost]) -> Void) -> Void {
    
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                
          //QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr
            
                
                //Use errors using completion handler
                
                /* 
                
                var alert = UIAlertController(title: "Hey", message: "This is  one Alert", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Working!!", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                */
                
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            if let JSONData = data {
                
                if let json: AnyObject = try! NSJSONSerialization.JSONObjectWithData(JSONData, options: NSJSONReadingOptions.MutableContainers) {
                    
                    if let jsonDictionary = json as? NSDictionary {
                        
                        print("Dictionary received")
                        print(jsonDictionary)
                        
                        print("RESPONSE TEST")
                        print(response)
                        
                        guard let httpResponse = response as? NSHTTPURLResponse else {
                                
                                SwiftSpinner.hide()
                            
                            
                            
                            
                                return
                            
                        }
                        
                        print("code \(httpResponse.statusCode)")
                        
                        if httpResponse.statusCode == 200  {
                            
                            let dataArray = jsonDictionary["results"] as! NSArray
                            
                            for subJson in dataArray  {
                                
                                let pinPoint: LocationPost = LocationPost(
                                    
                                    firstname: subJson["firstName"]! as! String,
                                    lastname: subJson["lastName"]! as! String!,
                                    mediaUrl: subJson["mediaURL"]! as! String!,
                                    
                                    latitude: subJson["latitude"]! as! Double,
                                    longitude: subJson["longitude"] as! Double
                                    
                                )
                                
                                
                                StudentLocationsClient.sharedInstance.studentLocations.append(pinPoint)
                                //test
                                
                            }
                            
                            print("LOCATIONS")
                            print(StudentLocationsClient.sharedInstance.studentLocations)
                            
                            
                            completionHandler(StudentLocationsClient.sharedInstance.studentLocations)

                            
                        
                        } else {
                        
                         

                            
                        
                        }
                        
                        
                        
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
    
    
    class func postSessionNative(username: String, password: String, completionHandler: (Bool) -> Void) {
    
        SwiftSpinner.show("Authenticating...")
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
                SwiftSpinner.show((error?.localizedDescription)!, animated: false).addTapHandler({
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
    
    class func getPublicDataNative(key: String) {
    
        print("GETTING PUBLIC DATA")
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/" + key)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                
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
            UserLocation.key = responseJSON?["user"]!["key"]! as! String
            
            
            
        }
        task.resume()
        
    }
    
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