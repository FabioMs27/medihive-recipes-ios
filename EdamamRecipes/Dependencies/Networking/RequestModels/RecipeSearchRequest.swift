//
//  RecipeSearchRequest.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 29.09.2024.
//

import Foundation

struct RecipeSearchRequest {
    let query: String
    
    // Filtering by ingredients and calories
    let calories: String?
    let ingredients: String?
    
    // Health and diet filters
    let diet: [String]
    let health: [String]
    
    init(
        query: String,
        calories: String? = .none,
        ingredients: String? = .none,
        diet: [String] = [],
        health: [String] = []
    ) {
        self.query = query
        self.calories = calories
        self.ingredients = ingredients
        self.diet = diet
        self.health = health
    }
}

// MARK: - QueryBuilder
extension RecipeSearchRequest {
    // Convert to a query dictionary
    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "calories", optional: calories),
            URLQueryItem(name: "ingr", optional: ingredients),
            URLQueryItem(name: "diet", optional: diet.isEmpty ? nil : diet.joined(separator: ",")),
            URLQueryItem(name: "health", optional: health.isEmpty ? nil : health.joined(separator: ",")),
        ].compactMap { $0 }
    }
}
