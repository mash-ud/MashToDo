 //
//  AppDelegate.swift
//  MashToDo
//
//  Created by Mashud on 3/3/19.
//  Copyright © 2019 Mashud. All rights reserved.
//

import UIKit
 import RealmSwift
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        do
        {
            let _ = try Realm()
        }
        catch
        {
            print("Error initialising Realm")
        }
        
        return true
    }

   
    

}

