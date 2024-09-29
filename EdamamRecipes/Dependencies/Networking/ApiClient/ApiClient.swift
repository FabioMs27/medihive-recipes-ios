//
//  ApiClient.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Foundation

struct ApiClient {
    typealias Suggestion = String
    
    var fetchRecipes: (_ request: RecipeSearchRequest) async throws -> [Recipe]
    var fetchRecipeSuggestions: (_ query: String) async throws -> [Suggestion]
}

// MARK: - Live
extension ApiClient {
    static func live(agent: NetworkAgent) -> Self {
        .init(
            fetchRecipes: { request in
                let response: RecipesResponse = try await agent.run(EdamamAPI.recipes(request))
                return .init(response)
            },
            
            fetchRecipeSuggestions: { query in
                try await agent.run(EdamamAPI.recipeSuggestions(query: query))
            }
        )
    }
}
