//
//  EdamamRecipesApp.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import SwiftUI

@main
struct EdamamRecipesApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RecipesView(viewModel: .init())
            }
        }
    }
}
