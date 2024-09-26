//
//  RecipesViewModelTests.swift
//  EdamamRecipesTests
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Dependencies
import XCTest
@testable import EdamamRecipes

final class RecipesViewModelTests: XCTestCase {

    func testSearchingRecipes_Success() async {
        let mockedResponse = RecipesResponse.init(
            from: 0,
            to: 9,
            count: 10,
            hits: [.init(recipe: .mock, bookmarked: .none)]
        )
        
        let sut = withDependencies {
            $0.networkClient.fetchRecipes = { _, _ in
                mockedResponse
            }
        } operation: {
            RecipesViewModel()
        }
        
        await sut.fetchRecipes(query: "Salad")
        
        XCTAssertNil(sut.requestState)
        XCTAssertEqual(sut.recipesResponse?.count, mockedResponse.count)
        XCTAssertEqual(sut.recipesResponse?.to, mockedResponse.to)
        XCTAssertEqual(sut.recipesResponse?.from, mockedResponse.from)
        XCTAssertEqual(sut.recipesResponse?.hits.count, mockedResponse.hits.count)
    }

    func testSearchingRecipes_Failure() async {
        let sut = withDependencies {
            $0.networkClient.fetchRecipes = { _, _ in
                throw NSError(domain: "TestDomain", code: 500)
            }
        } operation: {
            RecipesViewModel()
        }
        
        await sut.fetchRecipes(query: "Salad")
        
        XCTAssertEqual(sut.requestState, .error(description: "An error occurred. Please try again later"))
        XCTAssertNil(sut.recipesResponse)
    }
}
