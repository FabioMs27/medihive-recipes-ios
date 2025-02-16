//
//  EdamamRecipesApp.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import ComposableArchitecture
import SwiftUI

@main
struct EdamamRecipesApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RecipesView.init(
                    store: Store(initialState: RecipesFeature.State()) {
                        RecipesFeature()
                    }
                )
            }
            .tint(.black)
        }
    }
}
