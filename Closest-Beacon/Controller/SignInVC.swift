//
//  SignInVC.swift
//  Closest-Beacon
//
//  Created by Josh Kaplan on 3/6/18.
//  Copyright © 2018 Josh Kaplan. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func onUserTableViewTapped(_ sender: Any) {
    }
    
    
    @IBAction func onSignInTapped(_ sender: Any) {
        
       self.navigationController?.isNavigationBarHidden = true
        
        guard let email = emailTextField.text,
        email != "",
        let password = passwordTextField.text,
        password != ""
            else {
                AlertController.showAlert(self, title: "Missing Info", message: "Please fill out both fields")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                return
            }
            
            // If there is no error, assume user is successfully logged in.
            
            if(!(error != nil)) {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.isUserLoggedIn = true
            }
            
            guard let user = user else { return }
            print(user.email ?? "Missing Email")
            print(user.displayName ?? "Missing Display Name")
            print(user.uid)
            
            self.performSegue(withIdentifier: "signInSegue", sender: nil)
            
        }
        
    }
    
    
    
    
}
