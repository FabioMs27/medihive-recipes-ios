//
//  NetworkClientMock.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Foundation
import Dependencies
import XCTestDynamicOverlay

// MARK: - Mock
extension NetworkClient {
    static var mock: Self {
        .init(
            fetchRecipes: { _, _ in
                .init(
                    from: 21,
                    to: 40,
                    count: 4831,
                    hits: [
                        .init(recipe: .mock, bookmarked: .random())
                    ]
                )
            }
        )
    }
    
    static let failing = Self.init(
        fetchRecipes: unimplemented("\(Self.self).pathUpdateStream method not implemented.")
    )
}

// MARK: - Dependencies
extension NetworkClient: DependencyKey {
    public static let liveValue = NetworkClient.live(agent: .init())
    public static let previewValue = NetworkClient.mock
    public static let testValue = NetworkClient.failing
}

extension DependencyValues {
    var networkClient: NetworkClient {
        get { self[NetworkClient.self] }
        set { self[NetworkClient.self] = newValue }
    }
}
