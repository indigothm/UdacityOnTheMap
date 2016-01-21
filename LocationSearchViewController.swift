//
//  LocationSearchViewController.swift
//  OneTheMap
//
//  Created by Ilia Tikhomirov on 09/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import UIKit
import MapKit
import SwiftSpinner

class LocationSearchViewController: UIViewController, UITextFieldDelegate {
    
    
    func presentError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelDidTouch(sender: AnyObject) {
        
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: {})
    }
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    let geocoder = CLGeocoder()
    
    @IBOutlet weak var searchTextField: UITextField!
    
    func configureUI() {
        /* Configure tap recognizer */
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
        searchTextField.delegate = self
        
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findOnTheMapDidTouch(sender: AnyObject) {
        
        let address = searchTextField.text
        
         SwiftSpinner.show("Searching for location")
        
        geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
            
            
            if((error) != nil){
                
                print("Error", error)
                
                SwiftSpinner.show("Invalid Location", animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
                
                
            }
            if let placemark = placemarks?.first {
                
                SwiftSpinner.hide()
                
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                print (coordinates)
                
                let controller = self.storyboard?.instantiateViewControllerWithIdentifier("linkView") as! LinkViewController
                
                controller.coordinates = coordinates
                controller.placeMark = placemark
                
                UserLocation.mapString = address!
                UserLocation.longitude = coordinates.longitude
                UserLocation.latitude = coordinates.latitude
                
                self.presentViewController(controller, animated: true, completion: nil)
                
            }
        })
            

        
        
    }
    

}

extension LocationSearchViewController {
    
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
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue 
        return keyboardSize.CGRectValue().height
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
}
