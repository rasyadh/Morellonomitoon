//
//  SourceManagerClient.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 30/11/25.
//

import ComposableArchitecture

extension DependencyValues {
    var sourceManager: SourceManager {
        get { self[SourceManagerKey.self] }
        set { self[SourceManagerKey.self] = newValue }
    }
}

private enum SourceManagerKey: DependencyKey {
    static let liveValue = SourceManager()
}
