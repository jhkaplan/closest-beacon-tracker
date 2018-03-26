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
    
    
    
    
    
    // signOutUser
    @IBAction func onSignOutTapped(_ sender: Any) {
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
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Your Location"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        
        
        // Start writing to database
        
        post()
        
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways) {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startRangingBeacons(in: region)
        
    }
    
    @IBAction func viewUserLocationTableOnTapped(_ sender: Any) {
        viewUserLocationTable()
    }
    
    @IBAction func viewUesrLocationTableOnTapped2(_ sender: Any) {
        viewUserLocationTable()
    }
    @IBAction func viewUserListOnTapped(_ sender: Any) {
        viewUserList()
    }
    
    
    
    
    func setUserDisplayName() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let userDisplayName2 = dictionary["name"] as! String
                self.navigationItem.title = userDisplayName2
            }
        }
    }
    
    func viewUserLocationTable() {
        let viewController = UserLocationTableVC()
        show(viewController, sender: self)
    }
    
    func viewUserList() {
        let userViewController = UserListController()
        show(userViewController, sender: self)
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
        let postTime = ServerValue.timestamp()
        
        
        let post :  [String : AnyObject] = ["user" : user as AnyObject,
                                            "location" : currentBeacon as AnyObject,
                                            "eventTime" : eventTime as AnyObject,
                                            "postTime" : postTime as AnyObject
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
