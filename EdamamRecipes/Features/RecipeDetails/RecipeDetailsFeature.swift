//
//  RecipeDetailsFeature.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 16.02.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RecipeDetailsFeature {

    enum RequestState: Equatable {
        case inFlight
        case error(description: String)
    }

    @ObservableState
    struct State {
        var recipe: Recipe
        var requestState: RequestState? = .none
        
        var output: RecipeDetails.Output {
            .init(recipe: recipe)
        }
    }

    enum Action {
        case onAppearTask
        case fetchRecipeDetails(Recipe.ID)
        case fetchRecipeSuccess(Recipe)
        case fetchRecipeFailure(Error)
    }
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchRecipeDetails(let id):
                state.requestState = .inFlight
                return .run { send in
                    do {
                        let recipe = try await apiClient.fetchRecipeDetails(id)
                        await send(.fetchRecipeSuccess(recipe))
                    } catch {
                        await send(.fetchRecipeFailure(error))
                    }
                }
                
            case .onAppearTask:
                return .send(.fetchRecipeDetails(state.recipe.id))
                
            case .fetchRecipeSuccess(let recipe):
                state.recipe = recipe
                return .none
                
            case .fetchRecipeFailure(let error):
                state.requestState = .error(description: "An error occurred. Please try again later")
                print("Error fetching recipe details: \(error.localizedDescription)")
                return .none
            }
        }
    }
}
