//
//  RecipesView.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Dependencies
import SwiftUI

struct RecipesView: View {
    @ObservedObject var viewModel: RecipesViewModel
    
    let collumns: [GridItem] = [
        .init(spacing: 16),
        .init(spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: collumns, spacing: 16) {
                ForEach(
                    viewModel.recipeListItems,
                    content: makeRecipeItemView
                )
            }
            .padding(.horizontal)
        }
        .searchable(
            text: $viewModel.searchQuery,
            prompt: "Find the best recipes!"
        )
        .navigationTitle("Recipes")
        .task {
            await viewModel.observeSearchQuery()
        }
    }
    
    func makeRecipeItemView(_ recipe: Recipes.Output.Item) -> some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(
                url: recipe.imageUrl,
                transaction: Transaction(animation: .easeInOut)
            ) { phase in
                switch phase {
                case .empty, .failure:
                    Color.gray.opacity(0.3)
                case .success(let image):
                    image.resizable()
                @unknown default:
                    Color.gray.opacity(0.3)
                }
            }
            .scaleEffect(1)
            .aspectRatio(contentMode: .fit)
            .overlay(gradientOverlay)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.recipeName)
                    .bold()
                    .font(.caption)
                    .foregroundStyle(.white)
                    .lineLimit(2, reservesSpace: true)
                
                Text(recipe.source)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding(10)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    var gradientOverlay: some View {
        LinearGradient(
            gradient: Gradient(
                stops: [
                    .init(color: Color.black.opacity(0.1), location: 0.0),
                    .init(color: Color.black.opacity(0.2), location: 0.6),
                    .init(color: Color.black.opacity(0.8), location: 0.85),
                    .init(color: Color.black, location: 1)
                ]
            ),
            startPoint: UnitPoint(x: 0.5, y: 0.0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
    }
}

#Preview {
    NavigationStack {
        RecipesView(
            viewModel: withDependencies {
                $0.networkClient.fetchRecipes = { _, _ in
                    RecipesResponse.init(
                        from: 0,
                        to: 10,
                        count: 100,
                        hits: (0...10).map { _ in
                                .init(recipe: .mock, bookmarked: .random())
                        }
                    )
                }
            } operation: {
                .init()
            }
        )
    }
}
