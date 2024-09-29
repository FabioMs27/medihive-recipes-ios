//
//  RecipesFilter.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 29.09.2024.
//

import Foundation

enum RecipesFilter {
    struct Settings {
        var healthOptions: [HealthOptions] = []
        var dietOptions: [DietOptions] = []
    }
}

extension RecipesFilter.Settings {
    enum Options {
        case health(HealthOptions)
        case diet(DietOptions)
    }
    
    enum HealthOptions: String, CaseIterable {
        case vegetarian
        case vegan
        case paleo
        case sugarConscious   = "sugar-conscious"
        case alcaholFree
        case immunoSupportive = "immuno-supportive"
        case glutenFree       = "gluten-free"
        case dairyFree        = "dairy-free"
        case eggFree          = "egg-free"
        case soyFree          = "soy-free"
        case wheatFree        = "wheat-free"
        case fishFree         = "fish-free"
        case shellfishFree    = "shellfish-free"
        case treeNutFree      = "tree-nut-free"
        case peanutFree       = "peanut-free"
    }
    
    enum DietOptions: String, CaseIterable {
        case highFiber   = "high-fiber"
        case highProtein = "high-protein"
        case lowCarb     = "low-ccarb"
        case lowFat      = "low-fat"
        case lowSodium   = "low-sodium"
        case balanced
    }
}

extension RecipesFilter.Settings.HealthOptions {
    var displayText: String {
        switch self {
        case .vegetarian:
            "Vegetarian"
        case .vegan:
            "Vegan"
        case .paleo:
            "Paleo"
        case .sugarConscious:
            "Low-Sugar"
        case .alcaholFree:
            "Alcahol-Free"
        case .immunoSupportive:
            "Immunity"
        case .glutenFree:
            "Gluten"
        case .dairyFree:
            "Dairy"
        case .eggFree:
            "Eggs"
        case .soyFree:
            "Soy"
        case .wheatFree:
            "Wheat"
        case .fishFree:
            "Fish"
        case .shellfishFree:
            "ShellFish"
        case .treeNutFree:
            "Tree Nuts"
        case .peanutFree:
            "Peanuts"
        }
    }
}

extension RecipesFilter.Settings.DietOptions {
    var displayText: String {
        switch self {
        case .highFiber:
            "High-Fiber"
        case .highProtein:
            "High-Protein"
        case .lowCarb:
            "Low-Carb"
        case .lowFat:
            "Low-Fat"
        case .lowSodium:
            "Low-Sodium"
        case .balanced:
            "Balanced"
        }
    }
}
