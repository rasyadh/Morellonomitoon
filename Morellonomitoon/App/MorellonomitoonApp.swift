//
//  MorellonomitoonApp.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import ComposableArchitecture
import SwiftUI
import SwiftData

@main
struct MorellonomitoonApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: MorellonomitoonApp.store)
            .preferredColorScheme(.dark)
        }
        .modelContainer(for: MangaEntity.self)
    }
}
