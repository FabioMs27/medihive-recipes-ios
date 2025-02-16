//
//  RecipesFilterFeature.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 15.02.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RecipesFilterFeature {
    @ObservableState
    struct State {
        let id: UUID
        var filterSettings = RecipesFilter.Settings()
        
        init(
            id: UUID = .init(),
            filterSettings: RecipesFilter.Settings = .init()
        ) {
            self.id = id
            self.filterSettings = filterSettings
        }
    }
    
    enum Action {
        enum Delegate {
            case applyFilter(RecipesFilter.Settings)
        }
        
        case toggleFilterOptionTapped(RecipesFilter.Settings.Options)
        case applyFilterTapped
        case delegate(Delegate)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            func toggleFilter(options: RecipesFilter.Settings.Options) {
                switch options {
                case .diet(let option) where state.filterSettings.dietOptions.contains(option):
                    state.filterSettings.dietOptions.removeAll(where: { $0 == option })
                    
                case .diet(let option):
                    state.filterSettings.dietOptions.append(option)
                    
                case .health(let option) where state.filterSettings.healthOptions.contains(option):
                    state.filterSettings.healthOptions.removeAll(where: { $0 == option })
                    
                case .health(let option):
                    state.filterSettings.healthOptions.append(option)
                }
            }
            
            // MARK: - Actions
            switch action {
            case .applyFilterTapped:
                return .send(.delegate(.applyFilter(state.filterSettings)))
                
            case .toggleFilterOptionTapped(let options):
                toggleFilter(options: options)
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
