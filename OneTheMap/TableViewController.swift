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
    
    @IBAction func logoutAction(sender: AnyObject) {
        
        UdacityClient.logOut()
        self.dismissViewControllerAnimated(false, completion: nil)
        print("done")
        
    }
    
    var dataArray: [LocationPost] = []
    
    @IBAction func refreshDidTouch(sender: AnyObject) {
        
        SwiftSpinner.show("Loading...")
        
        UdacityClient.getLocationsNative({ data in
            
            guard data.isEmpty else {
                
            print(data)

            self.dataArray = data
            self.tableViewMain.reloadData()
                
            SwiftSpinner.hide()
             
            return
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
        
        UdacityClient.getLocationsNative({ data in
            
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                
            SwiftSpinner.show("Loading...")
            
            guard data.isEmpty else {
                
                print(data)
                
                self.dataArray = data
                self.tableViewMain.reloadData()
                
                SwiftSpinner.hide()
                
                return
            }
                
            }
            
            
        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("main", forIndexPath: indexPath) as! TableViewCell
        
        let row = indexPath.row
        cell.nameLabel.text = dataArray[row].firstname
        cell.infoLabel.text = dataArray[row].mediaUrl
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("OPEN SAFARI")
        
        UdacityClient.openSafari(dataArray[indexPath.row].mediaUrl)
        
        
        
    }
    

}
