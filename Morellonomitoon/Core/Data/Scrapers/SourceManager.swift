//
//  SourceManager.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 21/11/25.
//

import Foundation

class SourceManager {
    
    private let registry = SourceRegistry()
    var current: MangaSource
    
    private let defaultSource: MangaSource = MangabatClient()
    
    init() {
        self.current = registry.get(id: defaultSource.sourceID) ?? defaultSource
    }
    
    func switchSource(to id: String) {
        guard let source = registry.get(id: id) else {
            return
        }
        
        current = source
    }
    
    func allSources() -> [MangaSource] {
        registry.all()
    }
}
