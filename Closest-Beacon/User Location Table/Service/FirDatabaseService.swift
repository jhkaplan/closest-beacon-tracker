//
//  FirDatabaseService.swift
//  Closest-Beacon
//
//  Created by Josh Kaplan on 3/13/18.
//  Copyright © 2018 Josh Kaplan. All rights reserved.
//

import Foundation
import Firebase


class DatabaseService {
    
    // Set up Get session from firebase
    
    static let shared = DatabaseService()
    private init() {}
    
    var ref: DatabaseReference!
    let userLocationsReference = Database.database().reference().child("Locations")
    let userReference = Database.database().reference().child("Users")
    
    
}
