//
//  RecipesViewModelTests.swift
//  EdamamRecipesTests
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Dependencies
import XCTest
import XCTestDynamicOverlay
@testable import EdamamRecipes

final class RecipesViewModelTests: XCTestCase {

    func testSearchingRecipes_Success() async {
        let mockedRecipes = [Recipe.mock()]
        
        let sut = withDependencies {
            $0.apiClient.fetchRecipes = { _ in
                mockedRecipes
            }
        } operation: {
            RecipesViewModel(searchQuery: "Salad")
        }
        
        await sut.fetchRecipes()
        
        XCTAssertNil(sut.requestState)
        XCTAssertEqual(sut.recipes, mockedRecipes)
    }

    func testSearchingRecipes_Failure() async {
        let sut = withDependencies {
            $0.apiClient.fetchRecipes = { _ in
                throw NSError(domain: "TestDomain", code: 500)
            }
        } operation: {
            RecipesViewModel(searchQuery: "Salad")
        }
        
        await sut.fetchRecipes()
        
        XCTAssertEqual(sut.requestState, .error(description: "An error occurred. Please try again later"))
        XCTAssertTrue(sut.recipes.isEmpty)
    }
}

// MARK: - Fetch Suggestions
extension RecipesViewModelTests {
    func testSearchingSuggestions_Success() async {
        let sut = withDependencies {
            $0.apiClient.fetchRecipeSuggestions = { _ in
                ["Salad"]
            }
        } operation: {
            RecipesViewModel(suggestions: [])
        }
        
        XCTAssertTrue(sut.suggestions.isEmpty)
        await sut.fetchSuggestions(query: "Sala")
        XCTAssertEqual(sut.suggestions.first, "Salad")
    }
    
    func testSearchingSuggestions_Failure() async {
        let sut = withDependencies {
            $0.apiClient.fetchRecipeSuggestions = { _ in
                throw NSError(domain: "TestDomain", code: 500)
            }
        } operation: {
            RecipesViewModel(suggestions: ["Salad"])
        }
        
        XCTAssertFalse(sut.suggestions.isEmpty)
        await sut.fetchSuggestions(query: "Sala")
        XCTAssertTrue(sut.suggestions.isEmpty)
    }
}

// MARK: - Observer
extension RecipesViewModelTests {
    @MainActor
    func testObservingSearchQueryChanges() async {
        let scheduler = RunLoop.test
        var fetchCalledCount = 0
        let suggestion = "Sava"
        
        let sut = withDependencies {
            $0.mainRunLoop = scheduler.eraseToAnyScheduler()
            $0.apiClient.fetchRecipeSuggestions = { _ in
                fetchCalledCount += 1
                return [suggestion]
            }
            
        } operation: {
            // Drop first
            RecipesViewModel(
                searchQuery: "Salad",
                suggestions: [suggestion],
                debounceDuration: 0.5,
                minCharToSearch: 3
            )
        }
        
        let task = Task { await sut.observeSearchQuery() }
        async let observerTask: () = task.value
        await Task.yield()
        await scheduler.advance(by: 0.5)
        
        // Debounce
        sut.searchQuery = "Test1"
        await scheduler.advance(by: 0.1)
        sut.searchQuery = "Burger"
        await scheduler.advance(by: 0.5)
        
        // Remove Duplicated
        sut.searchQuery = "Burger"
        await scheduler.advance(by: 0.5)
        
        // Filter Suggestions
        sut.searchQuery = suggestion
        await scheduler.advance(by: 0.5)
        
        // Char limit to query suggestions
        sut.searchQuery = "12"
        await scheduler.advance(by: 0.5)
        
        task.cancel()
        await observerTask
        XCTAssertEqual(fetchCalledCount, 1)
    }
}
