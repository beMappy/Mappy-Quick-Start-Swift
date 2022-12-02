//
//  AppDelegate.swift
//  MappyQuickStart
//
//  Created by Mohamed Afsar on 23/06/22.
//

import UIKit
import Combine
import Mappy

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var cancellables = Set<AnyCancellable>()
    
    let clientId = <Your Client Id>
    let clientSecret = <Your Client Secret>
    
    var mappyUserId: String? {
        get {
            UserDefaults.standard.string(forKey: "\(clientId)_mp_userId")
        } set {
            UserDefaults.standard.set(newValue, forKey: "\(clientId)_mp_userId")
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //   Intialize Mappy
        MappyCore.initialize(clientId: clientId, secret: clientSecret, mappyUserId: mappyUserId)
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    print("Initialize: error: \(error)")
                }
            }, receiveValue: { [unowned self] in
                print("SDK Initialized: $0.mappyUserId: \($0.mappyUserId)")
                self.mappyUserId = $0.mappyUserId
            })
            .store(in: &cancellables)
        
        return true
    }
}

