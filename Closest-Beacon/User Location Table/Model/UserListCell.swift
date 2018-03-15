//
//  UserListCell.swift
//  Closest-Beacon
//
//  Created by Josh Kaplan on 3/13/18.
//  Copyright © 2018 Josh Kaplan. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userCurrentLocation: UILabel!
    @IBOutlet weak var userTimestamp: UILabel!
    
    
    func configure(withUserLocation locationData: locationData) {
        // Ties label on storyboard (left side) with data from LocationData.swift file (right side)
        userName.text = locationData.userName
        userCurrentLocation.text = locationData.userLocation
        userTimestamp.text = locationData.timestamp
        userProfileImage.image = locationData.userImage
        
    }
    
    
}
