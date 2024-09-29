//
//  RecipeDto.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 29.09.2024.
//

import Foundation

// MARK: - Top-level Model
struct RecipesResponse: Codable {
    let from: Int?
    let to: Int?
    let count: Int?
    let links: LinksDto?
    var hits: [HitDto]?

    enum CodingKeys: String, CodingKey {
        case from, to, count
        case links = "_links"
        case hits
    }
}

// MARK: - Links
struct LinksDto: Codable {
    let next: LinkDto
}

// MARK: - Link
struct LinkDto: Codable {
    let href: String
    let title: String
}

// MARK: - Hit
struct HitDto: Codable {
    let recipe: RecipeDto
    let bookmarked: Bool?
    let bought: Bool?
    let links: HitLinksDto

    enum CodingKeys: String, CodingKey {
        case recipe, bookmarked, bought
        case links = "_links"
    }
}

// MARK: - HitLinks
struct HitLinksDto: Codable {
    let selfLink: LinkDto

    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
    }
}

// MARK: - Recipe
struct RecipeDto: Codable {
    let uri: String
    let label: String
    let image: String
    let source: String
    let yield: Double
    let ingredientLines: [String]
    let calories: Double
}

// Retrieve Id from URI value to be used in the details request!
extension RecipeDto {
    var id: String? {
        // Split the URI by the "#" symbol to isolate the ID part
        let components = uri.split(separator: "#")
        
        // Ensure there are two components and the second one starts with "recipe_"
        if components.count == 2, components[1].hasPrefix("recipe_") {
            // Return the part after "recipe_"
            return String(components[1].dropFirst("recipe_".count))
        }
        return .none
    }
}

// MARK: - Mapping
extension Array where Element == Recipe {
    init(_ recipeResponse: RecipesResponse) {
        self = (recipeResponse.hits ?? [])
            .map(\.recipe)
            .map(Recipe.init)
    }
}

extension Recipe {
    init(recipeDto: RecipeDto) {
        self = .init(
            id: recipeDto.id ?? recipeDto.uri,
            label: recipeDto.label,
            imageUrl: URL(string: recipeDto.image),
            source: recipeDto.source,
            calories: recipeDto.calories
        )
    }
}
