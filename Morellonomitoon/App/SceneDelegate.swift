//
//  SceneDelegate.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 04/12/25.
//

import Combine
import ComposableArchitecture
import UIKit

@MainActor
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem) async -> Bool {
        guard let type = QuickActionType(shortcutItem: shortcutItem) else {
            return false
        }
        MorellonomitoonApp.store.send(.tab(.quickActionReceived(type)))
        
        return true
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let shortcutItem = connectionOptions.shortcutItem,
           let type = QuickActionType(shortcutItem: shortcutItem) {
            MorellonomitoonApp.store.send(.tab(.quickActionReceived(type)))
        }
    }
}
