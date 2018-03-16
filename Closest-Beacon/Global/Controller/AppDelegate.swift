//
//  AppDelegate.swift
//  Closest-Beacon
//
//  Created by Josh Kaplan on 2/21/18.
//  Copyright © 2018 Josh Kaplan. All rights reserved.
//

import UIKit
import Firebase



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
    var window: UIWindow?
    
    //publically accessible boolean value
    //used to determine what viewController to present when the app loads
    //this boolean is saved locally
    

    
    public var isUserLoggedIn: Bool {
        get {
            print("Returning Bool")
            return UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isUserLoggedIn")
            print("Set Bool")
            print(UserDefaults.standard.bool(forKey: "isUserLoggedIn"))
        }
    }


    // this gets a reference to the storyboard
    var storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController =
            UINavigationController(rootViewController: UserLocationTableVC())
        

//        // Start setting initial view if user is logged in (from Finn)
//
//        var initialViewController:UIViewController
//
//        // if user is already logged in, set initial view controller as MainVC
//
//        if(isUserLoggedIn) {
//            initialViewController = storyBoard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
//        }
//
//        // if user is NOT logged in, then set first viewController as SignInVC
//        else {
//            initialViewController = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
//        }
//
//        // Make the initialVC a Navigation Controller - allows to perform the push segues
//
//        let navigationInitialController = UINavigationController(rootViewController: initialViewController)
//
//        self.window = UIWindow()
//
//        // The rootViewController is the first viewController that is presented by the app
//        self.window?.rootViewController = navigationInitialController
//        self.window?.makeKeyAndVisible()
//
 
        
        
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

