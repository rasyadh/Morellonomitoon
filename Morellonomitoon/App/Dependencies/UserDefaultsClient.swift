//
//  UserDefaultsClient.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 30/11/25.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct UserDefaultsClient {
    var loadStringArray: (_ key: String) -> [String] = { _ in [] }
    var saveStringArray: (_ key: String, _ array: [String]) -> Void
}

extension UserDefaultsClient: DependencyKey {
    static let liveValue = UserDefaultsClient(
        loadStringArray: { key in
            UserDefaults.standard.stringArray(forKey: key) ?? []
        },
        saveStringArray: { key, array in
            UserDefaults.standard.set(array, forKey: key)
        }
    )
    
    static let testValue = UserDefaultsClient(
        loadStringArray: { _ in [] },
        saveStringArray: { _, _ in }
    )
    
    static let previewValue = UserDefaultsClient(
            loadStringArray: { _ in ["One Piece", "Naruto", "Jujutsu Kaisen"] },
            saveStringArray: { _, _ in }
        )
}

extension DependencyValues {
    var userDefaults: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}
