//
//  RecipeDetailsDto.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 29.09.2024.
//

import Foundation

// MARK: - RecipeDetailsResponse
struct RecipeDetailsResponse: Codable {
    let recipe: RecipeDetailsDto
}

// MARK: - RecipeDto
struct RecipeDetailsDto: Codable {
    let uri: String
    let label: String
    let image: String
    let images: RecipeImagesDto?
    let source: String
    let url: String?
    let shareAs: String?
    let yield: Int?
    let dietLabels, healthLabels, cautions, ingredientLines: [String]?
    let ingredients: [IngredientDto]?
    let calories, totalWeight: Double
    let glycemicIndex, inflammatoryIndex, totalCO2Emissions: Double?
    let co2EmissionsClass: String?
    let cuisineType, mealType, dishType, instructions, tags: [String]?
    let externalId: String?
    let totalNutrients, totalDaily: [String: NutrientInfoDto]?
}

// MARK: - IngredientDto
struct IngredientDto: Codable {
    let text: String
    let quantity: Double?
    let measure, food: String?
    let weight: Double?
    let foodId: String?
}

// MARK: - RecipeImagesDto
struct RecipeImagesDto: Codable {
    let thumbnail, small, regular, large: ImageDetailDto?

    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
        case large = "LARGE"
    }
}

// MARK: - ImageDetailDto
struct ImageDetailDto: Codable {
    let url: String
    let width, height: Int?
}

// MARK: - NutrientInfoDto
struct NutrientInfoDto: Codable {
    let label: String
    let quantity: Double?
    let unit: String?
}

// MARK: - Mapping
extension Recipe {
    init(recipeDetailsResponse: RecipeDetailsResponse, formattedId: String) {
        let recipeDto = recipeDetailsResponse.recipe
        self = .init(
            id: formattedId,
            label: recipeDto.label,
            imageUrl: URL(string: recipeDto.image),
            source: recipeDto.source,
            calories: recipeDto.calories,
            details: .init(
                ingredients: recipeDto.ingredientLines ?? [],
                nutrition: .init(
                    calories: recipeDto.calories,
                    glycemicIndex: recipeDto.glycemicIndex,
                    inflammatoryIndex: recipeDto.inflammatoryIndex,
                    totalCO2Emissions: recipeDto.totalCO2Emissions,
                    totalWeight: recipeDto.totalWeight,
                    dietLabels: recipeDto.dietLabels ?? [],
                    healthLabels: recipeDto.healthLabels ?? []
                )
            )
        )
    }
}
