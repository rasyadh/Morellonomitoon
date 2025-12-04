//
//  String+Extension.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 30/11/25.
//

import Foundation

extension String {
    
    func toUnderscore() -> String {
        self.replacingOccurrences(
            of: "[^A-Za-z0-9]+",
            with: "_",
            options: .regularExpression
        )
        .trimmingCharacters(in: CharacterSet(charactersIn: "_"))
    }
}
