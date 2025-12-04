//
//  DeeplinkHandler.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import Foundation

struct DeepLinkHandler {
    func parse(url: URL) -> AppRoute? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let path = components?.path.split(separator: "/") ?? []

        // morellonomitoon://manga/123
        if path.first == "manga", path.count == 2 {
            return .mangaDetail(id: String(path[1]))
        }

        // morellonomitoon://reader/abc
        if path.first == "reader", path.count == 2 {
            return .chapterReader(chapterId: String(path[1]))
        }

        return nil
    }
}
