//
//  ViewController.swift
//  Closest-Beacon
//
//  Created by Josh Kaplan on 2/21/18.
//  Copyright © 2018 Josh Kaplan. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase
import FirebaseAuthUI
import GoogleSignIn



class ViewController: UIViewController, CLLocationManagerDelegate, GIDSignInUIDelegate {
    @IBOutlet weak var locationName: UILabel!
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")! as UUID, identifier: "Estimotes")
    let colors = [
        38865: UIColor(red: 46/255, green: 49/255, blue: 146/255, alpha: 1),
        14477: UIColor(red: 159/255, green: 205/255, blue: 174/255, alpha: 1),
    ]
    let label = [
        38865: "Blueberry Office",
        14477: "Mint Benoit"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways) {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startRangingBeacons(in: region)
        
        
        // Start writing to database
        
        func post(){
            
            let user = "Josh"
            let currentBeacon = "Beacon"
            let eventTime = NSDate().timeIntervalSince1970            
            
            
            let post :  [String : AnyObject] = ["user" : user as AnyObject,
                                                "location" : currentBeacon as AnyObject,
                                                "eventTime" : eventTime as AnyObject
                                                ]
            
            let databaseREF = Database.database().reference()
            
            databaseREF.child("Locations").childByAutoId().setValue(post)
            
        }
        
        post()
        
<<<<<<< HEAD
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways) {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startRangingBeacons(in: region)
        
        // Add Google Sign in Button
        
        
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
=======
>>>>>>> parent of 06f01e4... Start writing hardcoded data and time to Firebase
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            self.view.backgroundColor = self.colors[closestBeacon.minor.intValue]
            self.locationName.text = self.label[closestBeacon.minor.intValue]
        }
        
    }


}

