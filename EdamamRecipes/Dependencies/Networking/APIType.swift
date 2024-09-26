//
//  APIType.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Foundation

protocol APIType {
    var baseURL: URL { get }
    var components: URLComponents? { get }
    var method: String { get }
    var headers: [String: String] { get }
}

extension APIType {
    var urlRequest: URLRequest? {
        guard let url = components?.url else { return .none }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        return request
    }
}
