//
//  Setting.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 13/12/25.
//

import Foundation

public struct Setting: Codable, Equatable, Sendable {
    
    public let chapterOrderAscending: Bool
    public let isVerticalReader: Bool
    public let mangaSource: MangaSources
    
    public init(
        chapterOrderAscending: Bool = false,
        isVerticalReader: Bool = true,
        mangaSource: MangaSources = .mangabat
    ) {
        self.chapterOrderAscending = chapterOrderAscending
        self.isVerticalReader = isVerticalReader
        self.mangaSource = mangaSource
    }
}

public extension Setting? {
    
    var isChapterAsc: Bool {
        get { return self?.chapterOrderAscending == true }
    }
    
    var isReaderVertical: Bool {
        get { return self?.isVerticalReader == true }
    }
}
