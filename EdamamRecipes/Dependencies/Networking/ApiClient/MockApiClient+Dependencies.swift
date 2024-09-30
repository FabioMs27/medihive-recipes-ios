//
//  ApiClientMock.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Foundation
import Dependencies
import XCTestDynamicOverlay

// MARK: - Mock
extension ApiClient {
    static var mock: Self {
        .init(
            fetchRecipes: { _ in
                (0...10).map {
                    Recipe.mock(id: "\($0)")
                }
            },
            fetchRecipeDetails: { _ in .mock(details: .mock) },
            fetchRecipeSuggestions: { _ in
                ["sava", "sama", "sago", "sake", "salt", "sage", "saag", "save", "samoa", "sabji"]
            }
        )
    }
    
    static let failing = Self.init(
        fetchRecipes: unimplemented("\(Self.self).fetchRecipes method not implemented."),
        fetchRecipeDetails: unimplemented("\(Self.self).fetchRecipeDetails method not implemented."),
        fetchRecipeSuggestions: unimplemented("\(Self.self).fetchRecipeSuggestions method not implemented.")
    )
}

// MARK: - Dependencies
extension ApiClient: DependencyKey {
    public static let liveValue = ApiClient.live(agent: .init())
    public static let previewValue = ApiClient.mock
    public static let testValue = ApiClient.failing
}

extension DependencyValues {
    var apiClient: ApiClient {
        get { self[ApiClient.self] }
        set { self[ApiClient.self] = newValue }
    }
}
