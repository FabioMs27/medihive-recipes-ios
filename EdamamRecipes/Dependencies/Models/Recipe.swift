//
//  Recipe.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Foundation

// MARK: - Recipe
struct Recipe: Codable, Identifiable, Equatable {
    let id: String
    let label: String
    let imageUrl: URL?
    let source: String
    let calories: Double
    let details: Details?
}

extension Recipe {
    struct Details: Codable, Equatable {
        let ingredients: [String]
        let nutrition: Nutrition
    }
    
    struct Nutrition: Codable, Equatable {
        let calories: Double
        let glycemicIndex: Double?
        let inflammatoryIndex: Double?
        let totalCO2Emissions: Double?
        let totalWeight: Double
        let dietLabels, healthLabels: [String]
    }
}

// MARK: - Mock
extension Recipe {
    static func mock(
        id: String = "4249d92069034f7f8c6f33039ac45f02",
        details: Details? = .none
    ) -> Self {
        Self.init(
            id: id,
            label: "Arugula, Peach & Goat Cheese Salad with Cherry Dressing",
            imageUrl: .none,
            source: "Food52",
            calories: 779,
            details: details
        )
    }
}

extension Recipe.Details {
    static let mock = Self.init(
        ingredients: [
            "3 tablespoons frozen passion fruit juice concentrate, thawed",
            "3 tablespoons minced shallot",
            "4 teaspoons Sherry wine vinegar",
            "1 teaspoon Dijon mustard",
            "1 teaspoon whole coriander seeds, coarsely cracked",
            "3 tablespoons olive oil",
            "8 cups herb salad mix (about 4 ounces)",
            "1 large ripe mango, halved, pitted, peeled, sliced",
            "2 small avocados, halved, pitted, peeled, sliced",
        ],
        nutrition: .init(
            calories: 293,
            glycemicIndex: 15,
            inflammatoryIndex: 2,
            totalCO2Emissions: 2,
            totalWeight: 55,
            dietLabels: RecipesFilter.Settings.DietOptions.allCases.map(\.rawValue),
            healthLabels: RecipesFilter.Settings.HealthOptions.allCases.map(\.rawValue)
        )
    )
}
