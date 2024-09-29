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
    let links: LinksDto

    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
    }
}

// MARK: - RecipeDto
struct RecipeDetailsDto: Codable {
    let uri: String
    let label: String
    let image: String
    let images: RecipeImagesDto
    let source: String
    let url: String
    let shareAs: String
    let yield: Int
    let dietLabels, healthLabels, cautions, ingredientLines: [String]
    let ingredients: [IngredientDto]
    let calories, glycemicIndex, inflammatoryIndex, totalCO2Emissions, totalWeight: Double
    let co2EmissionsClass: String
    let cuisineType, mealType, dishType, instructions, tags: [String]
    let externalId: String
    let totalNutrients, totalDaily: [String: NutrientInfoDto]
    let digest: [DigestDto]
}

// MARK: - DigestDto
struct DigestDto: Codable {
    let label: String
    let tag: String
    let schemaOrgTag: String?
    let total: Double
    let hasRDI: Bool
    let daily: Double
    let unit: String
    let sub: String?
}

// MARK: - IngredientDto
struct IngredientDto: Codable {
    let text: String
    let quantity: Double
    let measure, food: String
    let weight: Double
    let foodId: String
}

// MARK: - RecipeImagesDto
struct RecipeImagesDto: Codable {
    let thumbnail, small, regular, large: ImageDetailDto

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
    let width, height: Int
}

// MARK: - NutrientInfoDto
struct NutrientInfoDto: Codable {
    let label: String
    let quantity: Double
    let unit: String
}
