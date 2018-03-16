//
//  LoginRegisterVC.swift
//  Closest-Beacon
//
//  Created by Josh Kaplan on 3/14/18.
//  Copyright © 2018 Josh Kaplan. All rights reserved.
//

import UIKit
import Firebase

class UserLocationTableVC: UITableViewController {
    
    let cellId = "cellId"
    var location = [UserLocation]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        
        checkIfUserIsLoggedIn()
        fetchUserLocations()
    }
    
    // Check if user is logged in
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else {
            /* Set Navbar title as current user name
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
            })
        */
            self.navigationItem.title = "User Locations"
        }
    }
    
    func fetchUserLocations() {
        Database.database().reference().child("Locations").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let location = UserLocation()
                print(dictionary)
                location.setValuesForKeys(dictionary)
            }
//            print(snapshot)
        }, withCancel: nil)
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
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        cell.textLabel?.text = "Dummy Text"
        
        return cell
    }


}
