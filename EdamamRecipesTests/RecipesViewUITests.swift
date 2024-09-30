//
//  RecipesViewUITests.swift
//  EdamamRecipesTests
//
//  Created by Fábio Maciel de Sousa on 30.09.2024.
//

import Dependencies
import SnapshotTesting
import SwiftUI
import XCTest
import XCTestDynamicOverlay
@testable import EdamamRecipes

final class RecipesViewUITests: XCTestCase {  }

@MainActor
extension RecipesViewUITests {
    func testDisplayingRecipeList() {
        let mockRecipes: [Recipe] = (1...10).map { .mock(id: "\($0)") }
        let viewModel = withDependencies {
            $0.apiClient.fetchRecipes = { _ in mockRecipes }
        } operation: {
            RecipesViewModel(recipes: mockRecipes)
        }
        
        let sut = NavigationStack {
            RecipesView(viewModel: viewModel)
        }
        
        
        assertSnapshot(
            of: sut,
            as: .image(precision: 0.98, layout: .device(config: .iPhone13Pro)),
            record: false
        )
    }
    
    func testRecipesView_EmptyState() {
        let viewModel = withDependencies {
            $0.apiClient.fetchRecipes = { _ in [] }
        } operation: {
            RecipesViewModel()
        }
        
        let sut = NavigationStack {
            RecipesView(viewModel: viewModel)
        }
        
        assertSnapshot(
            of: sut,
            as: .image(precision: 0.98, layout: .device(config: .iPhone13Pro)),
            record: false
        )
    }
    
    func testRecipesView_ErrorState() {
        let viewModel = withDependencies {
            $0.apiClient.fetchRecipes = { _ in
                throw NSError(domain: "Test", code: 500)
            }
        } operation: {
            RecipesViewModel(requestState: .error(description: "An error has occurred!"))
        }
        
        let sut = NavigationStack {
            RecipesView(viewModel: viewModel)
        }
        
        assertSnapshot(
            of: sut,
            as: .image(precision: 0.98, layout: .device(config: .iPhone13Pro)),
            record: false
        )
    }
}
