//
//  RecipesFeature.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 16.02.2025.
//

import Foundation
import ComposableArchitecture
import SwiftNavigation
import Dependencies

@Reducer
struct RecipesFeature {
    @CasePathable
    enum Route: Equatable {
        case filterSheet
        case recipeDetails(StoreOf<RecipeDetailsFeature>)
    }
    
    enum RequestState: Equatable {
        case inFlight
        case error(description: String)
    }
    
    @ObservableState
    struct State {
        var searchQuery: String
        fileprivate var previousSearchQuery: String?
        var route: Route?
        var requestState: RequestState?
        var recipes: [Recipe]
        var suggestions: [String]
        var recipesFilter: RecipesFilterFeature.State
        let debounceDuration: TimeInterval
        let minCharToSearch: Int
        
        var filterSettings: RecipesFilter.Settings {
            recipesFilter.filterSettings
        }
        
        var recipeListItems: [Recipes.Output.Item] {
            recipes.map(Recipes.Output.Item.init)
        }
        
        init(
            searchQuery: String = "Salad",
            previousSearchQuery: String? = .none,
            route: Route? = .none,
            requestState: RequestState? = .none,
            recipes: [Recipe] = [],
            suggestions: [String] = [],
            recipesFilter: RecipesFilterFeature.State = .init(),
            debounceDuration: TimeInterval = 0.5,
            minCharToSearch: Int = 3
        ) {
            self.searchQuery = searchQuery
            self.route = route
            self.requestState = requestState
            self.recipes = recipes
            self.suggestions = suggestions
            self.recipesFilter = recipesFilter
            self.debounceDuration = debounceDuration
            self.minCharToSearch = minCharToSearch
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case clearSuggestions
        case filterTapped
        case recipeTapped(Recipe.ID)
        case onSearchSubmit
        case onAppearTask
        case setPreviousSearchQuery(String)
        // Delegate
        case recipesFilter(RecipesFilterFeature.Action)
        // Fetch Recipes
        case fetchRecipes(RecipeSearchRequest)
        case fetchRecipesSuccess([Recipe])
        case fetchRecipesFailure(Error)
        // Fetch Suggestions
        case fetchSuggestions(query: String)
        case fetchSuggestionsSuccess(suggestions: [String])
        case fetchSuggestionsFailure(Error)
    }
    
    enum CancelID {
        case debounceSearchQuery
    }
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.mainRunLoop) var mainRunLoop
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.recipesFilter, action: \.recipesFilter) {
            RecipesFilterFeature()
        }
        
        Reduce { state, action in
            // MARK: - Navigation
            func showRecipeDetailsScreen(from recipeId: String) {
                guard let recipe = state.recipes.first(where: { $0.id == recipeId }) else {
                    assertionFailure("Tried showing details of invalid recipe")
                    return
                }
                let store = StoreOf<RecipeDetailsFeature>.init(
                    initialState: RecipeDetailsFeature.State(recipe: recipe)
                ) {
                    RecipeDetailsFeature()
                }
                state.route = .recipeDetails(store)
            }
            
            // MARK: - Actions
            switch action {
            case .binding(\.searchQuery):
                guard
                    state.suggestions.contains(state.searchQuery),
                    state.requestState != .inFlight,
                    state.searchQuery.count > state.minCharToSearch,
                    state.searchQuery != state.previousSearchQuery
                else {
                    return .send(.setPreviousSearchQuery(state.searchQuery))
                }
                return .merge(
                    .send(.fetchSuggestions(query: state.searchQuery))
                    .debounce(
                        id: CancelID.debounceSearchQuery,
                        for: .seconds(state.debounceDuration),
                        scheduler: mainRunLoop
                    ),
                    .send(.setPreviousSearchQuery(state.searchQuery))
                )
                
            case .binding:
                return .none
                
            case .clearSuggestions:
                state.suggestions = []
                return .none
                
            case .filterTapped:
                state.route = .filterSheet
                return .none
                
            case .recipeTapped(let recipeId):
                showRecipeDetailsScreen(from: recipeId)
                return .none
                
            case .onAppearTask:
                return .send(.fetchRecipes(.init(
                    query: state.searchQuery,
                    filterSettings: state.filterSettings
                )))
                
            case .onSearchSubmit:
                return .merge(
                    .send(.fetchRecipes(.init(
                        query: state.searchQuery,
                        filterSettings: state.filterSettings
                    ))),
                    .send(.clearSuggestions)
                )
                
            case .recipesFilter(.delegate(.applyFilter(let filterSettings))):
                state.recipesFilter.filterSettings = filterSettings
                state.route = .none
                return .send(.fetchRecipes(.init(
                    query: state.searchQuery,
                    filterSettings: state.filterSettings
                )))
                
            case .recipesFilter:
                return .none
                
            case .fetchRecipes(let request):
                state.requestState = .inFlight
                return .run { send in
                    do {
                        let recipes = try await apiClient.fetchRecipes(request)
                        await send(.fetchRecipesSuccess(recipes))
                    } catch {
                        await send(.fetchRecipesFailure(error))
                    }
                }
                
            case .fetchRecipesSuccess(let recipes):
                state.recipes = recipes
                state.requestState = .none
                return .none

            case .fetchRecipesFailure(let error):
                state.requestState = .error(description: "An error occurred. Please try again later")
                print("Error fetching recipes: \(error.localizedDescription)")
                return .none
                
            case .fetchSuggestions(query: let query):
                return .run { send in
                    do {
                        let suggestions = try await apiClient.fetchRecipeSuggestions(query)
                        await send(.fetchSuggestionsSuccess(suggestions: suggestions))
                    } catch {
                        await send(.fetchSuggestionsFailure(error))
                    }
                }
                
            case .fetchSuggestionsSuccess(suggestions: let suggestions):
                state.suggestions = suggestions
                return .none
                
            case .fetchSuggestionsFailure(let error):
                state.suggestions = []
                print("Error fetching suggestions: \(error.localizedDescription)")
                return .none
                
            case .setPreviousSearchQuery(let searchQuery):
                state.previousSearchQuery = searchQuery
                return .none
            }
        }
    }
}
