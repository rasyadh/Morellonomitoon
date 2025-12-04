//
//  GenericExploreParam.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 02/12/25.
//

import Foundation

enum GenericExploreType: Equatable {
    case genre
    case latest
    case hotest
    case newest
}

struct GenericExploreParam: Equatable {
    let id: String
    let name: String
    let type: GenericExploreType
    
    init(id: String,
         name: String,
         type: GenericExploreType = .genre) {
        self.id = id
        self.name = name
        self.type = type
    }
}
