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
}

// MARK: - Mock
extension Recipe {
    static func mock(
        id: String = "4249d92069034f7f8c6f33039ac45f02"
    ) -> Self {
        Self.init(
            id: id,
            label: "Arugula, Peach & Goat Cheese Salad with Cherry Dressing",
            imageUrl: .none,
            source: "Food52",
            calories: 779
        )
    }
}
