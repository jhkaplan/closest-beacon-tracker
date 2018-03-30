//
//  UserLocation.swift
//  Closest-Beacon
//
//  Created by Josh Kaplan on 3/14/18.
//  Copyright © 2018 Josh Kaplan. All rights reserved.
//

import UIKit

class UserLocation: NSObject {
    
    var userName: String?
    var location: String?
    var eventTime: String?
    var barrelID: String?
    
    //    var userAvatar: UIImage
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "eventTime": self.eventTime = value as? String
        case "user": self.userName = value as? String
        case "location": self.location = value as? String
        case "barrelID": self.barrelID = value as? String
        default: return
        }
    }
    
    override func value(forKey key: String) -> Any? {
        switch  key {
        case "eventTime": return self.eventTime
        case "user": return self.userName
        case "location": return self.location
        case "barrelID": return self.barrelID
        default: return nil
        }
    }

}
