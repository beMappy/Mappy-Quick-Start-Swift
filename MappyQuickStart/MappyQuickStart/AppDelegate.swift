//
//  AppDelegate.swift
//  MappyQuickStart
//
//  Created by Mohamed Afsar on 23/06/22.
//

import UIKit
import Mappy

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //   Intialize Mappy
        MappyCore.initialize(clientId: <Your Client Id>, secret: <Your Client Secret>, completion: { error in
            print("SDK initialized. Error?: \(String(describing: error))")
        })
        
        return true
    }
}

