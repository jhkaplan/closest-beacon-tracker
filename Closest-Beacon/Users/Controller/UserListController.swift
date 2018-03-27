//
//  UserListController.swift
//  Closest-Beacon
//
//  Created by Josh Kaplan on 3/26/18.
//  Copyright © 2018 Josh Kaplan. All rights reserved.
//

import UIKit
import Firebase

class UserListController: UITableViewController {
    
    let cellId = "cellId"
    
    var userList = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Users"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
        
//        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showUserLocation)))
    }
    
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.name = dictionary["name"] as! String
                user.email = dictionary["email"] as! String
                self.userList.append(user)
                self.tableView.reloadData()
                
            }
            
        }, withCancel: nil)
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let user = userList[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.userList[indexPath.row]
        let userLocationTableVC = UserLocationTableVC()
        userLocationTableVC.selectedUser = user.name
        navigationController?.pushViewController(userLocationTableVC, animated: true)
        print("Selected User:", user.name)
    }
    
}

class UserCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
