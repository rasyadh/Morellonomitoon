//
//  SettingDTO.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 13/12/25.
//

import Foundation

public struct SettingDTO: Sendable {
    public let chapterOrderAscending: Bool
    public let isVerticalReader: Bool
    public let mangaSource: MangaSources
}
