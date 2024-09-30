//
//  EdamamAPI.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Foundation

enum EdamamAPI {
    case recipes(RecipeSearchRequest)
    case recipeDetails(id: String)
    case recipeSuggestions(query: String)
}

extension EdamamAPI: APIType {
    var baseURL: URL {
        URL(string: "https://api.edamam.com")!
    }
    
    var appId: String {
        switch self {
        case .recipes, .recipeDetails:
            return "e203f04d"
        case .recipeSuggestions:
            return "21a60801"
        }
    }
    
    var appKey: String {
        switch self {
        case .recipes, .recipeDetails:
            return "d00752271db208c7c775cc696f6d7c28"

        case .recipeSuggestions:
            return "8d24659d0f896a3bc5eb83d2b965ad30"
        }
    }
    
    var components: URLComponents? {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "app_id", value: appId),
            URLQueryItem(name: "app_key", value: appKey),
            URLQueryItem(name: "type", value: "public"),
        ]
        components?.queryItems?.append(contentsOf: queryItems)
        components?.path = paths
        return components
    }
    
    var method: String {
        "GET"
    }
    
    var headers: [String : String] {
        ["accept": "application/json",
         "Accept-Language": "en"]
    }
    
    var paths: String {
        switch self {
        case .recipes:
            return "/api/recipes/v2"
        case .recipeDetails(let id):
            return "/api/recipes/v2/\(id)"
        case .recipeSuggestions:
            return "/auto-complete"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .recipes(let request):
            return request.queryItems
        case .recipeDetails:
            return []
        case .recipeSuggestions(let query):
            return [URLQueryItem(name: "q", value: query)]
        }
    }
}
