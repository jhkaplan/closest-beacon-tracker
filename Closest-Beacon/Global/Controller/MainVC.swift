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
    
    let hueColorXY = [
        // created from here: http://colormine.org/convert/rgb-to-yxy
        38865: String("0.18530457146662035,0.12130093315893441"),
        37987: String("0.2324933873564069,0.27935596849188454"),
        14477: String("0.2997147582023723,0.370383158784688")
    ]
    
    let hueAlert = [
        38865: String("none"),
        14477: String("lselect"),
        37987: String("none")
    ]
    

    let beaconLocation = [
        38865: "Taylor's Office",
        14477: "Benoit's Office",
//        9463: "Josh's Office",
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
    
    
    
    func post(){
        
        // define post to Firebase function
        
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
        
        
        // Blockchain API
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Cache-Control": "no-cache",
            "Postman-Token": "26a0ecef-12e2-1e8b-c0a7-398da5b84130"
        ]
        
        
        
        let postData = NSMutableData(data: "text=Location: \(currentBeacon!)".data(using: String.Encoding.utf8)!)
        postData.append("&user_name=User: \(user) ".data(using: String.Encoding.utf8)!)
//        postData.append("Minor=Minor: \(currentBeaconID!)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://blockchain.appsfight.com/v1.0/the-positive-company/mine-block/")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
        })
        print(postData)
        
        dataTask.resume()
    }
        
        
        
        
        
        
        ////////////////////                        Put call to Hue API    //////////////////////
        
//        let hueState : String = "true"
//        let huePostXY : String = hueColorXY[beaconID]!
//        let hueShowAlert : String = hueAlert[beaconID]!
//        let huePostBody = String(format: "\"on\":%@, \"xy\": [%@], \"alert\": \"%@\"", hueState, huePostXY, hueShowAlert)
//        // "on":true, "xy": [0.2324933873564069,0.27935596849188454]
//        let huePostBodyWrapped = String(format: "{%@}", huePostBody)
//        
//        let hueHeaders = [
//            "Cache-Control": "no-cache",
//            "Postman-Token": "9021550f-767f-4a68-cd6c-32782e4561f9"
//        ]
//        
//        let huePostData = NSData(data: huePostBodyWrapped.data(using: String.Encoding.utf8)!)
//        
//        let hueRequest = NSMutableURLRequest(url: NSURL(string: "http://192.168.1.11/api/-icvPrqsUu7q-hknOjUmwwbz59i1SwSlZEfKXyjh/lights/4/state")! as URL,
//                                          cachePolicy: .useProtocolCachePolicy,
//                                          timeoutInterval: 10.0)
//        hueRequest.httpMethod = "PUT"
//        hueRequest.allHTTPHeaderFields = hueHeaders
//        hueRequest.httpBody = huePostData as Data
//        
//        let hueSession = URLSession.shared
//        let hueDataTask = hueSession.dataTask(with: hueRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if (error != nil) {
//                print(error ?? "error")
//            } else {
//                let httpResponse = response as? HTTPURLResponse
//                print(httpResponse ?? "")
//            }
//        })
//        
//        hueDataTask.resume()
//        print("Alert:" + hueShowAlert)
//        print(huePostBody)
//    }
    
    
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
