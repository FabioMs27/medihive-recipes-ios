//
//  EdamamAPI.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Foundation

enum EdamamAPI {
    case recipes(query: String, pageSize: Int)
    case recipeDetails
}

extension EdamamAPI: APIType {
    var baseURL: URL {
        URL(string: "https://api.edamam.com")!
    }
    
    var appId: String {
        "e203f04d"
    }
    
    var appKey: String {
        "d00752271db208c7c775cc696f6d7c28"
    }
    
    var components: URLComponents? {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "app_id", value: appId),
            URLQueryItem(name: "app_key", value: appKey),
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
        "/api/recipes/v2"
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .recipes(let query, let pageSize):
            return [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "type", value: "public")
            ]
        case .recipeDetails:
            return []
        }
    }
}
