//
//  RecipesModals.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Foundation

enum Recipes {
    enum Output {  }
}

extension Recipes.Output {
    struct Item: Identifiable, Equatable {
        let id: String
        let recipeName: String
        let imageUrl: URL?
        let source: String
    }
}

// MARK: - Mapping
extension Recipes.Output.Item {
    init(recipe: Recipe) {
        self.init(
            id: recipe.id,
            recipeName: recipe.label,
            imageUrl: recipe.imageUrl,
            source: "by \(recipe.source)"
        )
    }
}

extension RecipeSearchRequest {
    init(query: String, filterSettings: RecipesFilter.Settings) {
        self = .init(
            query: query,
            calories: .none,
            ingredients: .none,
            diet: filterSettings.dietOptions.map(\.rawValue),
            health: filterSettings.healthOptions.map(\.rawValue)
        )
    }
}
