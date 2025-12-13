//
//  QuickActionType.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 04/12/25.
//

import Foundation
import UIKit

enum QuickActionType: String, Equatable {
    case search
    case bookmark
    
    init?(shortcutItem: UIApplicationShortcutItem) {
        self.init(rawValue: shortcutItem.type)
    }
}
