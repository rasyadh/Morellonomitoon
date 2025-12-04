//
//  MangaDTO.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 01/12/25.
//

import Foundation

public struct MangaDTO: Sendable {
    public let id: String
    public let title: String
    public let url: URL?
    public let thumbnailURL: URL?
    public let sourceID: String
    
    public let latestChapter: String?
    public let latestChapterURL: URL?
}
