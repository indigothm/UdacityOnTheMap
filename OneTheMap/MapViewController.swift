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
    

    @IBAction func refreshDidTouch(sender: AnyObject) {
        
        SwiftSpinner.show("Loading...")
        
        UdacityClient.getLocationsNative({ data in
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            
            
            
            guard data.isEmpty else {
            
            print(data)
            
            
            for point in data {
                
                self.mapView.addAnnotation(point)
                
            }

                
            SwiftSpinner.hide()
                
            return
                
            }
                
            
                
            }
            
        })
        
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let identifier = "Location"
        
        
        if annotation.isKindOfClass(LocationPost.self) {
            
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
        
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        let location = view.annotation as! LocationPost
        let url = location.subtitle
        
        UdacityClient.openSafari(url!)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.delegate = self
        mapView.delegate = self
        
        UdacityClient.getLocationsNative({ data in
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                
            SwiftSpinner.show("Loading...")
            
            print(data)
            
            for point in data {
            
            self.mapView.addAnnotation(point)
                
            SwiftSpinner.hide()
            
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
