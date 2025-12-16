//
//  SettingSheetFeature.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 13/12/25.
//

import ComposableArchitecture

@Reducer
struct SettingSheetFeature {
    
    @Dependency(\.databaseService) private var databaseService
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    struct State: Equatable {
        var isChapterOrderAsc: Bool = false
        var mangaSource: MangaSources = .mangabat
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case cancelButtonTapped
        case onChangeChapterOrder(Bool)
        case selectMangaSource(MangaSources)
        case settingResponse(Result<Setting, ResultError>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return fetchSetting()
                
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
                
            case let .onChangeChapterOrder(value):
                return saveSetting(
                    isChapterOrderAsc: value,
                    mangaSource: state.mangaSource
                )
                
            case let .selectMangaSource(value):
                return saveSetting(
                    isChapterOrderAsc: state.isChapterOrderAsc,
                    mangaSource: value
                )
                
            case let .settingResponse(.success(result)):
                state.isChapterOrderAsc = result.chapterOrderAscending
                state.mangaSource = result.mangaSource
                return .none
                
            case .settingResponse(.failure(_)):
                return .none
                
            case .binding:
                return .none
            }
        }
    }
    
    private func fetchSetting() -> Effect<Action> {
        .run { [databaseService] send in
            do {
                guard let setting = try await databaseService.fetchSetting() else {
                    let defaultSetting = await Setting()
                    try await databaseService.saveSetting(setting: defaultSetting)
                    
                    await send(.settingResponse(.success(defaultSetting)))
                    return
                }
                await send(.settingResponse(.success(setting)))
            } catch {
                await send(.settingResponse(.failure(ResultError.from(error))))
            }
        }
    }
    
    private func saveSetting(isChapterOrderAsc: Bool, mangaSource: MangaSources) -> Effect<Action> {
        .run { [databaseService] send in
            try await databaseService.saveSetting(setting: Setting(
                chapterOrderAscending: isChapterOrderAsc,
                mangaSource: mangaSource
            ))
        }
    }
}
