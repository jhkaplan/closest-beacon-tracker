//
//  CustomTableCell.swift
//  Closest-Beacon
//
//  Created by Josh Kaplan on 3/9/18.
//  Copyright © 2018 Josh Kaplan. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    
    var userName: String?
    var userCurrentLocation: String?
    var userLocationTimestamp: String?
    var userProfile : UIImage?
    
    var userNameView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    var  userCurrentLocationView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var  userLocationTimestampView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var  userProfileView : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(userNameView)
        self.addSubview(userCurrentLocationView)
        self.addSubview(userLocationTimestampView)
        self.addSubview(userProfileView)
        
        
        /* Profile Image Section */
        // Places and aligns the User Profile image alog the left side of the cell
        let imageWidth: Int = 80
        userProfileView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        userProfileView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        userProfileView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        userProfileView.widthAnchor.constraint(equalToConstant: CGFloat(imageWidth)).isActive = true
        // Sets image radius
        userProfileView.layer.cornerRadius = CGFloat(imageWidth)/2
        userProfileView.clipsToBounds = true
        // makes image in square format
        userProfileView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        /* User Name Section */
        // Places and aligns the User Name alog the right side of the cell
        userNameView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        userNameView.bottomAnchor.constraint(equalTo: self.userCurrentLocationView.topAnchor).isActive = true
        userNameView.leftAnchor.constraint(equalTo: self.userProfileView.rightAnchor).isActive = true
        userNameView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        

        
        /*  User Location Section */
        userCurrentLocationView.topAnchor.constraint(equalTo: self.userNameView.bottomAnchor).isActive = true
        userCurrentLocationView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        userCurrentLocationView.leftAnchor.constraint(equalTo: self.userProfileView.rightAnchor).isActive = true
        userCurrentLocationView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        /* Add location timestamp information */

    }
    
    
    // Apply data information in to layout view/subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        if let userName = userName {
            userNameView.text = userName
        }
        if let userCurrentLocation = userCurrentLocation {
            userCurrentLocationView.text = "Current Location: \(userCurrentLocation)"
        }
        if let userProfile = userProfile {
            userProfileView.image = userProfile
        }
        if let userLocationTimestamp = userLocationTimestamp {
            userLocationTimestampView.text = userLocationTimestamp
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
