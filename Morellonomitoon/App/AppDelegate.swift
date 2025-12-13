//
//  AppDelegate.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 04/12/25.
//

import Combine
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
        sceneConfiguration.delegateClass = SceneDelegate.self
        
        return sceneConfiguration
    }
}
