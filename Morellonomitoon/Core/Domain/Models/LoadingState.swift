//
//  LoadingState.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import Foundation

enum LoadingState: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)
}
