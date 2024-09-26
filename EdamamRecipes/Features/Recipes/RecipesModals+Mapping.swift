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
        var id: UUID = .init()
        let recipeName: String
        let imageUrl: URL?
        let source: String
    }
}

// MARK: - Mapping
extension Recipes.Output.Item {
    init(recipeHit: Hit) {
        let recipe = recipeHit.recipe
        self.init(
            recipeName: recipe.label,
            imageUrl: recipe.image,
            source: "by \(recipe.source)"
        )
    }
}
