//
//  AppRoute.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import Foundation

enum AppRoute: Equatable, Sendable {
    case mangaDetail(id: String)
    case chapterReader(chapterId: String)
}

extension AppRoute: Identifiable {
    public var id: String {
        switch self {
        case .mangaDetail(let id): return "manga:\(id)"
        case .chapterReader(let id): return "chapter:\(id)"
        }
    }
}
