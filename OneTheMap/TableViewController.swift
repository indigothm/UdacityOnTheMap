//
//  TableViewController.swift
//  OneTheMap
//
//  Created by Ilia Tikhomirov on 07/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import UIKit
import SwiftSpinner

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableViewMain: UITableView!
    
    
    func presentError(title: String, message: String) {
        
        SwiftSpinner.hide()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        
        UdacityClient.logOut()
        self.dismissViewControllerAnimated(false, completion: nil)
        print("done")
        
    }
    
    
    @IBAction func refreshDidTouch(sender: AnyObject) {
        
        self.tableViewMain.reloadData()
        
        SwiftSpinner.show("Loading...")
        
        UdacityClient.getLocationsNative({ data, error, errorMessage in
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                
                
                if let _ = data
                    
                {
                    
                    self.tableViewMain.reloadData()
                    
                    
                    SwiftSpinner.hide()
                    
                } else {
                    
                    
                    if error {
                        
                        SwiftSpinner.hide()
                        
                        self.presentError("Error", message: errorMessage)
                        
                    } else
                        
                    {
                        SwiftSpinner.hide()
                        
                        self.presentError("Unknown Error", message: "Something went wrong")
                        
                    }
                    
                    
                }
                
            }
            
        })

        
        
       

        
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    @IBAction func addBtnDidTouch(sender: AnyObject) {
        
        let controller  = self.storyboard!.instantiateViewControllerWithIdentifier("locationViewController") as! LocationSearchViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navBar.delegate = self
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                
                
                self.tableViewMain.reloadData()
                
                
                
            
                
            }
            
            


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationsClient.sharedInstance.studentLocations.count
    }
 
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("main", forIndexPath: indexPath) as! TableViewCell
        
        let row = indexPath.row
        cell.nameLabel.text = StudentLocationsClient.sharedInstance.studentLocations[row].firstname
        cell.infoLabel.text = StudentLocationsClient.sharedInstance.studentLocations[row].mediaUrl
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("OPEN SAFARI")
        
        UdacityClient.openSafari(StudentLocationsClient.sharedInstance.studentLocations[indexPath.row].mediaUrl, completionHandeler: { error in
            
            if error == true {
                
                self.presentError("Url Error", message: "Incorect web address")
            
            }
            
        })
        
        
        
    }
    

}
