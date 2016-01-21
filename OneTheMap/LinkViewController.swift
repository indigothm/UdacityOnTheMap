//
//  LinkViewController.swift
//  OneTheMap
//
//  Created by Ilia Tikhomirov on 09/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import UIKit
import MapKit
import SwiftSpinner

class LinkViewController: UIViewController, UITextFieldDelegate {
    
    func presentError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBAction func cancelDidTouch(sender: AnyObject) {
                
        self.presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: {})
        
    }
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    var coordinates: CLLocationCoordinate2D!
    var placeMark: CLPlacemark!
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        congigureUI()
        print(coordinates)
        linkTextField.delegate = self
        
        let latitudinalMeters: CLLocationDistance = 200
        let longitudinalMeters: CLLocationDistance = 200
        
        let region = MKCoordinateRegionMakeWithDistance(coordinates, latitudinalMeters, longitudinalMeters)
        
        self.map.setRegion(region, animated: true)
        self.map.addAnnotation(MKPlacemark(placemark: placeMark))
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func congigureUI() {
    
        /* Configure tap recognizer */
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }


    @IBAction func submitDidTouch(sender: AnyObject) {
        
        
        
        UserLocation.mediaURL = self.linkTextField.text!
        print(UserLocation.mediaURL)
        print(UserLocation.firstname)
        print(UserLocation.latitude)
        print(UserLocation.longitude)
        print(UserLocation.lastname)
        print(UserLocation.mapString)
        print(UserLocation.key)
        //deploy POST METHOD
        
        //test POST method
        UdacityClient.postLocation(UserLocation.key, firstName: UserLocation.firstname, lastName: UserLocation.lastname, mapString: UserLocation.mapString, mediaURL: UserLocation.mediaURL, latitude: UserLocation.latitude, longitude: UserLocation.longitude, completionHandler: { status, error, errorMessage in
            
            if status {
                
                dispatch_async(dispatch_get_main_queue(), {
                
                self.presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: {})
                    
                })
                
            } else {
                
                if error {
                    
                     dispatch_async(dispatch_get_main_queue(), {
                    
                    SwiftSpinner.show("Posting Error", animated: false).addTapHandler({
                        SwiftSpinner.hide()
                    })
                        
                    })

                    
                } else
                    
                {
                    
                    self.presentError("Unknown Error", message: "Something went wrong")
                    
                }

            
            }
            
        })
    
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LinkViewController {
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification) / 2
            self.view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
}

