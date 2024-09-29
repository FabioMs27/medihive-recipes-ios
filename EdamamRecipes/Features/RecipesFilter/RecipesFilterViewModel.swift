//
//  RecipesFilterViewModel.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 29.09.2024.
//

import Foundation
import XCTestDynamicOverlay

class RecipesFilterViewModel: ObservableObject, Identifiable {
    
    let id: UUID
    @Published var filterSettings: RecipesFilter.Settings
    
    var applyFilter: @MainActor (RecipesFilter.Settings) async -> Void = unimplemented("applyFilter method not implemented.")
    
    init(
        id: UUID = .init(),
        filterSettings: RecipesFilter.Settings = .init()
    ) {
        self.id = id
        self.filterSettings = filterSettings
    }
    
    func toggleFilterOption(_ option: RecipesFilter.Settings.Options) {
        switch option {
        case .diet(let option) where filterSettings.dietOptions.contains(option):
            filterSettings.dietOptions.removeAll(where: { $0 == option })
            
        case .diet(let option):
            filterSettings.dietOptions.append(option)
            
        case .health(let option) where filterSettings.healthOptions.contains(option):
            filterSettings.healthOptions.removeAll(where: { $0 == option })
            
        case .health(let option):
            filterSettings.healthOptions.append(option)
            
        }
    }
    
}
