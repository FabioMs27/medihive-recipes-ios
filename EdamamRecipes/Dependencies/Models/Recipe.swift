//
//  Recipe.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Foundation

struct RecipesResponse: Codable {
    let from: Int
    let to: Int
    let count: Int
    var hits: [Hit] = []
}

struct Hit: Codable {
    let recipe: Recipe
    var bookmarked: Bool? = false
}

// MARK: - Recipe
struct Recipe: Codable {
    let uri: String
    let label: String
    let image: URL?
    let source: String
    let yield: Double
    let ingredientLines: [String]
    let calories: Double
}

// MARK: - Mock
extension Recipe {
    static let mock = Self.init(
        uri: "http://www.edamam.com/ontologies/edamam.owl#recipe_4249d92069034f7f8c6f33039ac45f02",
        label: "Arugula, Peach & Goat Cheese Salad with Cherry Dressing",
        image: .none,
        source: "Food52",
        yield: 4.0,
        ingredientLines: ["For the dressing:", "1/2 cup fresh or frozen cherries", "2 tablespoons water", "2 tablespoons mild flavored olive oil", "1 tablespoon lemon juice", "salt and pepper to taste", "For the salad:"],
        calories: 779
    )
}
