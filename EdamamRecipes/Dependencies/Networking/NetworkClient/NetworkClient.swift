//
//  NetworkClient.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Foundation

struct NetworkClient {
    var fetchRecipes: (_ query: String, _ pageSize: Int) async throws -> RecipesResponse
}

// MARK: - Live
extension NetworkClient {
    static func live(agent: NetworkAgent) -> Self {
        .init(
            fetchRecipes: { query, pageSize in
                try await agent.run(EdamamAPI.recipes(query: query, pageSize: pageSize))
            }
        )
    }
}
