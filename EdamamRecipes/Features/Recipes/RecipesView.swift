//
//  RecipesView.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 26.09.2024.
//

import ComposableArchitecture
import Dependencies
import SwiftUI
import SwiftUINavigation

struct RecipesView: View {
    @Bindable var store: StoreOf<RecipesFeature>
    @FocusState private var searchFocused: Bool
    @Environment(\.dismissSearch) var dismissSearch
    @Environment(\.isSearching) var isSearching
    @State var isPresentingSearch = false
    
    let collumns: [GridItem] = [
        .init(spacing: 16),
        .init(spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerView
                switch store.requestState {
                case .inFlight:
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                case .error(let description):
                    Text(description)
                        .bold()
                        .foregroundStyle(.red)
                case .none where store.recipes.isEmpty:
                    emptyState
                case .none:
                    LazyVGrid(columns: collumns, spacing: 16) {
                        ForEach(
                            store.recipeListItems,
                            content: makeRecipeItemView
                        )
                    }
                }
            }
            .animation(.easeIn, value: store.recipes)
            .animation(.easeIn, value: store.requestState)
            .padding(.horizontal)
        }
        .navigationTitle("Recipes")
        .searchable(
            text: $store.searchQuery,
            isPresented: $isPresentingSearch,
            prompt: "Find the best recipes!"
        )
        .focused($searchFocused)
        .searchSuggestions {
            ForEach(store.suggestions, id: \.self) { suggestion in
                Label(suggestion, systemImage: "bookmark")
                    .searchCompletion(suggestion)
            }
        }
        .submitLabel(.search)
        .onSubmit(of: .search) {
            searchFocused = false
            isPresentingSearch = false
            dismissSearch()
            hideKeyboard()
            store.send(.onSearchSubmit)
        }
        .task { store.send(.onAppearTask) }
        // MARK: - Navigation
        .sheet(isPresented: Binding($store.route.filterSheet)) {
            RecipesFilterView.init(
                store: self.store.scope(state: \.recipesFilter, action: \.recipesFilter)
            )
            .presentationDetents([.medium])
        }
        .navigationDestination(
            item: $store.route.recipeDetails,
            destination: RecipeDetailsView.init
        )
    }
    
    var headerView: some View {
        HStack {
            Text("Search Result")
            Spacer()
            Button {
                store.send(.filterTapped)
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
            We couldn't find any matches for "\(store.searchQuery)"
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
            store.send(.recipeTapped(recipe.id))
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
                .multilineTextAlignment(.leading)
                .padding(10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview("Recipes List") {
    NavigationStack {
        RecipesView.init(
            store: Store(initialState: RecipesFeature.State()) {
                RecipesFeature()
            }
        )
    }
}

#Preview("Error State") {
    NavigationStack {
        RecipesView.init(
            store: Store(
                initialState: RecipesFeature.State(),
                reducer: { RecipesFeature() },
                withDependencies: {
                    $0.apiClient.fetchRecipes = { _ in
                        throw NSError(domain: "Test", code: 500)
                    }
                }
            )
        )
    }
}

#Preview("Empty State") {
    NavigationStack {
        RecipesView.init(
            store: Store(
                initialState: RecipesFeature.State(),
                reducer: { RecipesFeature() },
                withDependencies: {
                    $0.apiClient.fetchRecipes = { _ in [] }
                }
            )
        )
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
