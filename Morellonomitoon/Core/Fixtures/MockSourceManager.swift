//
//  MockSourceManager.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 24/11/25.
//

import Foundation

final class MockSourceManager: SourceManager {
    
    init(popular: [Manga] = [],
         latest: [Manga] = [],
         hotest: [Manga] = [],
         newest: [Manga] = [],
         chapterReader: ChapterReader = .init(id: "", mangaID: "")
    ) {
        let mockSource = MockSourceClient()
        mockSource.mockPopular = popular
        mockSource.mockLatest = latest
        mockSource.mockHotest = hotest
        mockSource.mockNewest = newest
        mockSource.mockChapterReader = chapterReader
        
        super.init()
        self.current = mockSource
    }
}
