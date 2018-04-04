//
//  BarrelLocationListController.swift
//  Closest-Beacon
//
//  Created by Josh Kaplan on 4/2/18.
//  Copyright © 2018 Josh Kaplan. All rights reserved.
//

import UIKit
import Firebase

class BarrelLocationListController: UITableViewController {

    let cellID = "cellID"
    var barrelLocationList = [BarrelLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Barrel Locations"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        fetchBarrelLocation()

    }
    
    func fetchBarrelLocation() {
        
        Database.database().reference().child("barrelID").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let barrel = BarrelLocation()
                barrel.userName = dictionary["user"] as! String
                barrel.barrelID = dictionary["barrelID"] as! String
                barrel.barrelLocation = dictionary["location"] as! String
                barrel.checkinTimestamp = dictionary["eventTime"] as! String
                self.barrelLocationList.append(barrel)
                self.tableView.reloadData()
                
            }
        }, withCancel: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barrelLocationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let barrel = barrelLocationList[indexPath.row]
        cell.textLabel?.text = barrel.barrelID
        cell.detailTextLabel?.text = barrel.barrelLocation
        
        return cell
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

}

class barrelLocationCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
