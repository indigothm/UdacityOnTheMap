//
//  MapViewController.swift
//  OneTheMap
//
//  Created by Ilia Tikhomirov on 07/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import UIKit
import MapKit
import SwiftSpinner

class MapViewController: UIViewController, UINavigationBarDelegate, MKMapViewDelegate  {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBAction func logoutDidTouch(sender: AnyObject) {
        
        UdacityClient.logOut()
        self.dismissViewControllerAnimated(false, completion: nil)
        print("done")
        
    }
    
    @IBAction func addBtnDidTouch(sender: AnyObject) {
        
        let controller  = self.storyboard!.instantiateViewControllerWithIdentifier("locationViewController") as! LocationSearchViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func presentError(title: String, message: String) {
        
        SwiftSpinner.hide()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    
    }
    
    func createPins(dataArray:[LocationPost]){
        
        var annotations = [MKPointAnnotation]()
        
        for student in dataArray {
            //Creating singular pin
            let annotation = MKPointAnnotation()
            //Adding attributes to the pin
            annotation.coordinate = student.coordinate
            annotation.title = student.title
            annotation.subtitle = student.mediaUrl
            
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        
    }
    

    @IBAction func refreshDidTouch(sender: AnyObject) {
        
        SwiftSpinner.show("Loading...")
        
        UdacityClient.getLocationsNative({ data, error, errorMessage in
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            
            print("SHARED INSTANCE TEST")
            print(StudentLocationsClient.sharedInstance.studentLocations)
            
            if let output = data  {
            
            print(data)
            
            
            self.createPins(output)

                
            SwiftSpinner.hide()
                
            return
                
            } else {
                
                if error {
                
                    self.presentError("Error", message: errorMessage)
                    
                } else
                
                {
                    
                     self.presentError("Unknown Error", message: "Something went wrong")
                
                }

            }
                
            
                
            }
            
        })
        
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "Location"
        
        
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil {
                
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                
                let btn = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                
                annotationView!.annotation = annotation
            }
            
            return annotationView
        
        
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let location = view.annotation
        let url = location!.subtitle
        
        UdacityClient.openSafari(url!!, completionHandeler: { error in
            
            if error == true {
                
                self.presentError("Url Error", message: "Incorect web address")
                
            }
        
        })
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.delegate = self
        mapView.delegate = self
        
        UdacityClient.getLocationsNative({ data, error, errorMessage in
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                
            SwiftSpinner.show("Loading...")
            
            print(data)
                
            if let output = data
            
            {
                
                
                self.createPins(output)
                SwiftSpinner.hide()
                
            
                
            } else {
                
                
                if error {
                    
                    self.presentError("Error", message: errorMessage)
                    
                } else
                    
                {
                    
                    self.presentError("Unknown Error", message: "Something went wrong")
                    
                }

                
            }
                
            }
        
            })
        
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
