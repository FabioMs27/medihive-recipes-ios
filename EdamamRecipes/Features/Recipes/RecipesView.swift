//
//  RecipesView.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import Dependencies
import SwiftUI
import SwiftUINavigation

struct RecipesView: View {
    @ObservedObject var viewModel: RecipesViewModel
    @FocusState private var searchFocused: Bool
    @Environment(\.dismissSearch) var dismissSearch
    
    let collumns: [GridItem] = [
        .init(spacing: 16),
        .init(spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerView
                switch viewModel.requestState {
                case .inFlight:
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                case .error(let description):
                    Text(description)
                        .bold()
                        .foregroundStyle(.red)
                case .none where viewModel.recipes.isEmpty:
                    emptyState
                case .none:
                    LazyVGrid(columns: collumns, spacing: 16) {
                        ForEach(
                            viewModel.recipeListItems,
                            content: makeRecipeItemView
                        )
                    }
                }
            }
            .animation(.easeIn, value: viewModel.recipes)
            .animation(.easeIn, value: viewModel.requestState)
            .padding(.horizontal)
        }
        .navigationTitle("Recipes")
        .searchable(
            text: $viewModel.searchQuery,
            prompt: "Find the best recipes!"
        )
        .searchSuggestions {
            ForEach(viewModel.suggestions, id: \.self) { suggestion in
                Label(suggestion, systemImage: "bookmark")
                    .searchCompletion(suggestion)
            }
        }
        .focused($searchFocused)
        .submitLabel(.search)
        .onSubmit(of: .search) {
            searchFocused = false
            dismissSearch()
            viewModel.clearSuggestions()
            Task { await viewModel.fetchRecipes() }
        }
        .task { await viewModel.observeSearchQuery() }
        .task { await viewModel.fetchRecipes() }
        // MARK: - Navigation
        .sheet(item: $viewModel.route.filterSheet) { viewModel in
            RecipesFilterView(viewModel: viewModel)
                .presentationDetents([.medium])
        }
        .navigationDestination(
            item: $viewModel.route.recipeDetails,
            destination: RecipeDetailsView.init
        )
    }
    
    var headerView: some View {
        HStack {
            Text("Search Result")
            Spacer()
            Button {
                viewModel.showFilterSheet()
            } label: {
                Image.init(systemName: "slider.horizontal.3")
                    .padding(8)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(Color.white)
            }
        }
        .font(.title2)
        .bold()

    }
    
    var emptyState: some View {
        Text(
            """
            We couldn't find any matches for "\(viewModel.searchQuery)"
            Double check your search for any typos or spelling errors - or try a different search term.
            """
        )
            .bold()
            .foregroundStyle(.green)
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
    
    func makeRecipeItemView(_ recipe: Recipes.Output.Item) -> some View {
        Button {
            viewModel.showRecipeDetailsScreen(from: recipe.id)
        } label: {
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
    }
}

#Preview("Recipes List") {
    NavigationStack {
        RecipesView(viewModel: .init())
    }
}

#Preview("Error State") {
    NavigationStack {
        RecipesView(
            viewModel: withDependencies {
                $0.apiClient.fetchRecipes = { _ in
                    throw NSError(domain: "Test", code: 500)
                }
            } operation: {
                .init()
            }
        )
    }
}

#Preview("Empty State") {
    NavigationStack {
        RecipesView(
            viewModel: withDependencies {
                $0.apiClient.fetchRecipes = { _ in [] }
            } operation: {
                .init()
            }
        )
    }
}
