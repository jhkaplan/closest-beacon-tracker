//
//  AlertController.swift
//  Closest-Beacon
//
//  Created by Josh Kaplan on 3/6/18.
//  Copyright © 2018 Josh Kaplan. All rights reserved.
//

import Foundation
import UIKit

class AlertController {
    static func showAlert(_ inViewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        inViewController.present(alert, animated: true, completion: nil)
    }
}
