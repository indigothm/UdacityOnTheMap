//
//  LinkViewController.swift
//  OneTheMap
//
//  Created by Ilia Tikhomirov on 09/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import UIKit
import MapKit

class LinkViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    var coordinates: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(coordinates)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
