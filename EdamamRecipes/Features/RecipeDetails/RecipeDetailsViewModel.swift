//
//  RecipeDetailsViewModel.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 30.09.2024.
//

import Dependencies
import Foundation

class RecipeDetailsViewModel: ObservableObject {
    
    enum RequestState: Equatable {
        case inFlight
        case error(description: String)
    }
    
    @Dependency(\.apiClient) var apiClient
    
    @Published var recipe: Recipe
    @Published var requestState: RequestState?
    
    var output: RecipeDetails.Output {
        .init(recipe: recipe)
    }
    
    init(
        recipe: Recipe,
        requestState: RequestState? = .none
    ) {
        self.recipe = recipe
        self.requestState = requestState
    }
    
}

@MainActor
extension RecipeDetailsViewModel {
    func fetchRecipeDetails() async {
        do {
            requestState = .inFlight
            recipe = try await apiClient.fetchRecipeDetails(recipe.id)
            requestState = .none
        } catch {
            self.requestState = .error(description: "An error occurred. Please try again later")
            print("Error fetching recipe details: \(error.localizedDescription)")
        }
    }
}
