//
//  NetworkAgent.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
}

struct NetworkAgent {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func run<Response: Decodable>(url: URL?) async throws -> Response {
        guard let url else {
            throw NetworkError.invalidUrl
        }
        let (data, _) = try await session.data(from: url)
        return try decode(data)
    }
    
    func decode<Response: Decodable>(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Response.self, from: data)
    }
}
