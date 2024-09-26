//
//  RecipesViewModel.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Dependencies
import Foundation

class RecipesViewModel: ObservableObject {
    
    enum RequestState: Equatable {
        case inFlight
        case error(description: String)
    }
    
    @Dependency(\.networkClient) var networkClient
    @Dependency(\.mainQueue) var mainQueue
    
    @Published var searchQuery: String
    @Published var requestState: RequestState?
    @Published var recipesResponse: RecipesResponse?
    
    let debounceDuration: TimeInterval
    let minCharToSearch: Int
    let pageSize: Int
    
    var recipeListItems: [Recipes.Output.Item] {
        guard let hits = recipesResponse?.hits else { return [] }
        return hits.map { hit in
            Recipes.Output.Item.init(recipeHit: hit)
        }
    }
    
    init(
        searchQuery: String = "Salad",
        requestState: RequestState? = .none,
        recipesResponse: RecipesResponse? = .none,
        debounceDuration: TimeInterval = 0.5,
        minCharToSearch: Int = 3,
        pageSize: Int = 10
    ) {
        self.searchQuery = searchQuery
        self.requestState = requestState
        self.recipesResponse = recipesResponse
        self.debounceDuration = debounceDuration
        self.minCharToSearch = minCharToSearch
        self.pageSize = pageSize
    }
}

@MainActor
// MARK: - Requests + Observers
extension RecipesViewModel {
    func fetchRecipes(query: String) async {
        do {
            requestState = .inFlight
            recipesResponse = try await networkClient.fetchRecipes(query, pageSize)
            requestState = .none
        } catch {
            self.requestState = .error(description: "An error occurred. Please try again later")
            print("Error fetching recipes: \(error.localizedDescription)")
        }
    }
    
    func observeSearchQuery() async {
        let searchQuerySequence = $searchQuery
            .removeDuplicates()
            .debounce(
                for: .seconds(debounceDuration),
                scheduler: mainQueue
            )
            .values
        
        for try await newValue in searchQuerySequence where newValue.count > minCharToSearch {
            await fetchRecipes(query: newValue)
        }
    }
}
