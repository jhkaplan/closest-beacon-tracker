//
//  UserLocationVC.swift
//  Closest-Beacon
//
//  Created by Josh Kaplan on 3/13/18.
//  Copyright © 2018 Josh Kaplan. All rights reserved.
//
// https://jsonplaceholder.typicode.com/posts
// Load data from Firbase vid: https://youtu.be/YqpdgJ24R7E?t=43m23s

import UIKit
import Firebase

class UserLocationVC: UIViewController {
    @IBOutlet weak var pageTitle: UINavigationItem!
    
    var locations = [locationData]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Load data from firebase
        
        let pageTitle: String = "User Locations"
        print(pageTitle)
        
        navigationItem.title = "Josh"
        self.navigationItem.title = "Josh 2"
    }
    
    
    
    
        
        

}
