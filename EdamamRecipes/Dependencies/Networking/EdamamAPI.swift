//
//  EdamamAPI.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Foundation

enum EdamamAPI {
    case recipes
    case recipeDetails
}

extension EdamamAPI: APIType {
    var baseURL: URL {
        URL(string: "https://www.edamam.com")!
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
            URLQueryItem(name: "app_key", value: appKey)
        ]
        components?.queryItems?.append(contentsOf: queryItems)
        return components
    }
    
    var method: String {
        "GET"
    }
    
    var headers: [String : String] {
        [:]
    }
    
    var paths: String {
        ""
    }
    
    var queryItems: [URLQueryItem] {
        []
    }
}
