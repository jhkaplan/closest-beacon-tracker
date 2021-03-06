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
    var userLocationsList = [UserLocation]()
    var selectedUserName: String = ""
    var selectedUserEmail: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        checkIfUserIsLoggedIn()
        fetchUserLocations()
        
        print(selectedUserName, selectedUserEmail)
    }
    
    // Check if user is logged in
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else {
            self.navigationItem.title = selectedUserName
        }
    }
    
    
    func fetchUserLocations() {
        Database.database().reference().child("Locations").queryOrdered(byChild: "user").queryEqual(toValue: selectedUserEmail.lowercased()).observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let location = UserLocation()
                location.setValuesForKeys(dictionary)
                self.userLocationsList.insert(location, at: 0)
                self.tableView.reloadData()
            }
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
        return userLocationsList.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)

        
        let currentLocation = userLocationsList[indexPath.row]
        cell.textLabel?.text = currentLocation.userName
        let currentUserLocation = currentLocation.location ?? "Unknown"
        let userLocationCheckInTime = currentLocation.eventTime ?? "Unknown"
        cell.detailTextLabel?.text = "Current Location: \(String(describing: currentUserLocation)) as of \(userLocationCheckInTime)"
        
        
        
        return cell
    }

}
