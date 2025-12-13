//
//  SettingEntity.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 13/12/25.
//

import Foundation
import SwiftData

@Model
public final class SettingEntity {
    
    @Attribute(.unique) public var id: String
    public var chapterOrderAscending: Bool
    public var isVerticalReader: Bool
    public var mangaSource: MangaSources
    
    public init(
        id: String = "default",
        chapterOrderAscending: Bool = true,
        isVerticalReader: Bool = true,
        mangaSource: MangaSources = .mangabat
    ) {
        self.id = id
        self.chapterOrderAscending = chapterOrderAscending
        self.isVerticalReader = isVerticalReader
        self.mangaSource = mangaSource
    }
}

extension SettingEntity {
    
    func toDTO() -> Setting {
        .init(
            chapterOrderAscending: chapterOrderAscending,
            isVerticalReader: isVerticalReader,
            mangaSource: mangaSource
        )
    }
    
    func update(from dto: Setting) {
        chapterOrderAscending = dto.chapterOrderAscending
        isVerticalReader = dto.isVerticalReader
        mangaSource = dto.mangaSource
    }
}
