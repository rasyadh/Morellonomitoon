//
//  SourceRegistry.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 21/11/25.
//

import Foundation

final class SourceRegistry {
    
    private var sources: [String: MangaSource] = [:]
    
    init() {
        register(MangabatClient())
    }
    
    func register(_ source: MangaSource) {
        sources[source.sourceID] = source
    }
    
    func get(id: String) -> MangaSource? {
        sources[id]
    }
    
    func all() -> [MangaSource] {
        Array(sources.values)
    }
}
