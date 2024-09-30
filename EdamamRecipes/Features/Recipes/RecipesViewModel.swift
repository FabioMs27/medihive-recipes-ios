//
//  RecipesViewModel.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Dependencies
import Foundation
import SwiftUINavigation

class RecipesViewModel: ObservableObject {
    
    @CasePathable
    enum Route {
        case filterSheet(RecipesFilterViewModel)
        case recipeDetails(RecipeDetailsViewModel)
    }
    
    enum RequestState: Equatable {
        case inFlight
        case error(description: String)
    }
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.mainRunLoop) var mainRunLoop
    
    @Published var searchQuery: String
    @Published var route: Route?
    @Published var requestState: RequestState?
    @Published var recipes: [Recipe]
    @Published var suggestions: [String]
    
    var filterSettings: RecipesFilter.Settings
    let debounceDuration: TimeInterval
    let minCharToSearch: Int
    
    var recipeListItems: [Recipes.Output.Item] {
        recipes.map(Recipes.Output.Item.init)
    }
    
    init(
        searchQuery: String = "Salad",
        route: Route? = .none,
        requestState: RequestState? = .none,
        recipes: [Recipe] = [],
        suggestions: [String] = [],
        filterSettings: RecipesFilter.Settings = .init(),
        debounceDuration: TimeInterval = 0.5,
        minCharToSearch: Int = 3
    ) {
        self.searchQuery = searchQuery
        self.route = route
        self.requestState = requestState
        self.recipes = recipes
        self.suggestions = suggestions
        self.filterSettings = filterSettings
        self.debounceDuration = debounceDuration
        self.minCharToSearch = minCharToSearch
    }
    
    func clearSuggestions() {
        suggestions = []
    }
    
    func showFilterSheet() {
        let recipesFilterViewModel = withDependencies(from: self) {
            RecipesFilterViewModel.init(filterSettings: filterSettings)
        }
        route = .filterSheet(recipesFilterViewModel)
        bind(recipesFilterViewModel)
    }
    
    func showRecipeDetailsScreen(from recipeId: String) {
        guard let recipe = recipes.first(where: { $0.id == recipeId }) else {
            assertionFailure("Tried showing details of invalid recipe")
            return
        }
        let recipeDetailsViewModel = withDependencies(from: self) {
            RecipeDetailsViewModel.init(recipe: recipe)
        }
        route = .recipeDetails(recipeDetailsViewModel)
    }
}

// MARK: - Requests + Observers
@MainActor
extension RecipesViewModel {
    func fetchRecipes() async {
        do {
            requestState = .inFlight
            recipes = try await apiClient.fetchRecipes(.init(
                query: searchQuery,
                filterSettings: filterSettings
            ))
            requestState = .none
        } catch {
            self.requestState = .error(description: "An error occurred. Please try again later")
            print("Error fetching recipes: \(error.localizedDescription)")
        }
    }
    
    func fetchSuggestions(query: String) async {
        do {
            suggestions = try await apiClient.fetchRecipeSuggestions(query)
        } catch {
            suggestions = []
            print("Error fetching suggestions: \(error.localizedDescription)")
        }
    }
    
    func observeSearchQuery() async {
        let searchQuerySequence = $searchQuery
            .dropFirst()
            .removeDuplicates()
            .debounce(
                for: .seconds(debounceDuration),
                scheduler: mainRunLoop
            )
            .filter { !self.suggestions.contains($0) }
            .values
        
        for try await newValue in searchQuerySequence where newValue.count > minCharToSearch {
            await fetchSuggestions(query: newValue)
        }
        print("Oberver was cancelled!")
    }
}

// MARK: - Binding
extension RecipesViewModel {
    func bind(_ recipesFilterViewModel: RecipesFilterViewModel) {
        recipesFilterViewModel.applyFilter = { [weak self] settings in
            self?.filterSettings = settings
            self?.route = .none
            await self?.fetchRecipes()
        }
    }
}
