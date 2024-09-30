//
//  RecipeDetailsModels.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 30.09.2024.
//

import Foundation

enum RecipeDetails {  }

extension RecipeDetails {
    struct Output {
        let label: String
        let imageUrl: URL?
        let source: String
        let details: Details?
    }
    
    struct Details {
        let ingredientLines: [String]
        let nutritionItems: [NutritionItem]
        let nutritionTags: String
    }
    
    struct NutritionItem {
        let label: String
        let value: String
    }
}

extension RecipeDetails.NutritionItem {
    init?(label: String, value: Int?) {
        guard let value else { return nil }
        self = .init(label: label, value: "\(value)")
    }
}

extension Int {
    init?(_ double: Double?) {
        guard let double else { return nil }
        self = Int(double)
    }
}

extension RecipeDetails.Output {
    init(recipe: Recipe) {
        self = .init(
            label: recipe.label,
            imageUrl: recipe.imageUrl,
            source: recipe.source,
            details: .init(details: recipe.details)
        )
    }
}

extension RecipeDetails.Details {
    init?(details: Recipe.Details?) {
        guard let details else { return nil }
        self = .init(
            ingredientLines: details.ingredients,
            nutritionItems: [
                .init(label: "CALORIES", value: "\(Int(details.nutrition.calories))"),
                .init(label: "GLYCEMIC", value: Int(details.nutrition.glycemicIndex)),
                .init(label: "INFLAMMATORY", value: Int(details.nutrition.inflammatoryIndex)),
                .init(label: "CO2", value: Int(details.nutrition.totalCO2Emissions)),
                .init(label: "WEIGHT", value: "\(Int(details.nutrition.totalWeight))"),
            ].compactMap { $0 },
            nutritionTags: (details.nutrition.dietLabels + details.nutrition.healthLabels)
                .map { $0 }
                .joined(separator: ", ")
        )
    }
}
