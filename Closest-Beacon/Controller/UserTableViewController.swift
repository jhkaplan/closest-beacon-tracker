//
//  UserTableViewController.swift
//  Closest-Beacon
//
//  Created by Josh Kaplan on 3/9/18.
//  Copyright © 2018 Josh Kaplan. All rights reserved.
//

import UIKit

 struct userListCellData {
    let userName: String?
    let userCurrentLocation: String?
    let userLocationTimestamp: String?
    let image: UIImage?
    
}


class UserTableViewController: UITableViewController {
    
    var userLocationData = [userListCellData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLocationData = [userListCellData.init(userName: "Josh Kaplan", userCurrentLocation: "Josh's Office", userLocationTimestamp: "3/12/18 9:00 AM", image: #imageLiteral(resourceName: "joshkaplanheadshot_sq")),userListCellData.init(userName: "Benoit Terpereau", userCurrentLocation: "Benoit's Office", userLocationTimestamp: "3/12/18 4:00 PM", image: #imageLiteral(resourceName: "benoit_terpereau_headshot")),userListCellData.init(userName: "Taylor Allis", userCurrentLocation: "Chris Joseph's Office", userLocationTimestamp: "3/12/18 4:00 PM", image: #imageLiteral(resourceName: "taylorallis"))]
        
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: "custom")
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 400
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "custom") as! CustomCell
        cell.userProfile = userLocationData[indexPath.row].image
        cell.userName = userLocationData[indexPath.row].userName
        cell.userCurrentLocation = userLocationData[indexPath.row].userCurrentLocation
        cell.userLocationTimestamp = userLocationData[indexPath.row].userLocationTimestamp
        cell.layoutSubviews()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userLocationData.count
    }

}
