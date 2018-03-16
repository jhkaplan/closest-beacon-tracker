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


class MainVC: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var loggedInUserEmail: UILabel!
    
    
    //Sign out a user
    
     func signOutUser() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("User Signed Out")
            // Set user is logged out variable so next app load goes to login page
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.isUserLoggedIn = false
            self.performSegue(withIdentifier: "signOutSegue", sender: nil)
        }
        catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func onSignOutTapped(_ sender: Any) {
//        signOutUser()
        handleLogout()
    }
 
    
    var currentBeaconID: Int? = 37987
    
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")! as UUID, identifier: "Estimotes")
    let colors = [
        38865: UIColor(red: 46/255, green: 49/255, blue: 146/255, alpha: 1),
        14477: UIColor(red: 159/255, green: 205/255, blue: 174/255, alpha: 1),
        9463: UIColor(red: 110/255, green: 206/255, blue: 245/255, alpha: 1),
        37987: UIColor(red: 110/255, green: 206/255, blue: 245/255, alpha: 1),
        ]

    let beaconLocation = [
        38865: "Taylor's Office",
        14477: "Benoit's Office",
        9463: "Josh's Office",
        37987: "Josh's Office"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Hide navigation Bar
        
        self.navigationController?.isNavigationBarHidden = true
        
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        loggedInUserEmail.text = userEmail
        
        // Start writing to database
        
        post()
        
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways) {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startRangingBeacons(in: region)
        
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        present(loginController,animated: true, completion: nil)
    }
    
    // define post to Firebase function
    
    func post(){
        
        guard let beaconID = self.currentBeaconID else { return }
        guard let user: String = Auth.auth().currentUser?.email else { return }
        let currentBeacon = self.beaconLocation[beaconID]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let eventTime = dateFormatter.string(from: Date())
        
        
        let post :  [String : AnyObject] = ["user" : user as AnyObject,
                                            "location" : currentBeacon as AnyObject,
                                            "eventTime" : eventTime as AnyObject
        ]
        
        let databaseREF = Database.database().reference()
        
        databaseREF.child("Locations").childByAutoId().setValue(post)
        
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
            self.locationName.text = self.beaconLocation[closestBeacon.minor.intValue]
            if self.currentBeaconID != closestBeacon.minor.intValue {
                self.currentBeaconID = closestBeacon.minor.intValue
                self.post()
            }
        }
        
    }
}