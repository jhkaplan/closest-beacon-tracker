////
////  SignUpVC.swift
////  Closest-Beacon
////
////  Created by Josh Kaplan on 3/6/18.
////  Copyright © 2018 Josh Kaplan. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//class SignUpVC: UIViewController {
//
//    @IBOutlet weak var firstNameTextField: UITextField!
//    @IBOutlet weak var lastNameTextField: UITextField!
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//    
//    @IBAction func onRegisterTapped(_ sender: Any) {
//        
//        guard let firstName = firstNameTextField.text,
//        firstName != "",
//        let lastName = lastNameTextField.text,
//        lastName != "",
//        let email = emailTextField.text,
//        email != "",
//        let password = passwordTextField.text,
//        password != ""
//            else {
//                AlertController.showAlert(self, title: "Missing Info", message: "Please fill out all of the fields")
//                return
//        }
//        
//        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//            
//            guard error == nil else {
//                AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
//                return
//            }
//            
//            
//            // If there is no error, assume user is successfully logged in.
//            if(!(error != nil)) {
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.isUserLoggedIn = true
//            }
//            
//            
//            
//            guard let user = user else { return }
//            print(user.email ?? "Missing Email")
//            print(user.uid)
//            
//            let changeRequest = user.createProfileChangeRequest()
//            changeRequest.displayName = firstName + " " + lastName
//            changeRequest.commitChanges(completion: { (error) in
//                guard error == nil else {
//                    AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
//                    return
//                }
//                
//                self.performSegue(withIdentifier: "signUpSegue", sender: nil)
//                
//            })
// 
//            
//        }
//    }
//}

