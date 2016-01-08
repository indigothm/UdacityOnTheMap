//
//  MainToolbar.swift
//  OneTheMap
//
//  Created by Ilia Tikhomirov on 08/01/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import UIKit

class MainToolbar: UIToolbar {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setParams()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setParams()
    }
    
    func setParams() -> Void {
        
        let logoutBotton = UIBarButtonItem(title: "Logout", style: .Plain, target: nil, action: nil)
        let flex = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let fixed = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixed.width = 20.0
        
        let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: nil)
        
        let toolbarButtons = [logoutBotton, flex, add, fixed, refresh]
        
        
        self.setItems(toolbarButtons, animated: true)
    }

    

}
