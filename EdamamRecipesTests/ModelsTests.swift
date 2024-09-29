//
//  ModelsTests.swift
//  EdamamRecipesTests
//
//  Created by Fábio Maciel de Sousa on 29.09.2024.
//

import XCTest
@testable import EdamamRecipes

final class ModelsTests: XCTestCase {

    func testGettingIdFromRecipeDto() {
        let sut = RecipeDto(
            uri: "http://www.edamam.com/ontologies/edamam.owl#recipe_d07ecc3077e1497d83a15b31a33f73d2",
            label: "",
            image: "",
            source: "",
            yield: 0,
            ingredientLines: [],
            calories: 0
        )
        
        XCTAssertEqual(sut.id, "d07ecc3077e1497d83a15b31a33f73d2")
    }

}
