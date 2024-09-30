//
//  URLQueryItem.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 29.09.2024.
//

import Foundation

extension URLQueryItem {
    init?(name: String, optional wrappedValue: String?) {
        guard let value = wrappedValue else {
            return nil
        }
        self.init(name: name, value: value)
    }
}
