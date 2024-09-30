//
//  RecipeDetailsView.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 30.09.2024.
//

import Dependencies
import SwiftUI

struct RecipeDetailsView: View {
    @ObservedObject var viewModel: RecipeDetailsViewModel
    
    var output: RecipeDetails.Output {
        viewModel.output
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                imageView
                    .frame(
                        width: proxy.size.width,
                        height: proxy.size.height * 0.4
                    )
                    .aspectRatio(contentMode: .fit)
                
                ScrollView {
                    Spacer().frame(height: proxy.size.height * 0.4)
                    LazyVStack(spacing: 20) {
                        content
                            .padding(.bottom, 24)
                    }
                    .background(alignment: .top) {
                        Color.white.frame(height: proxy.size.height)
                    }
                }
                .scrollClipDisabled()
                .id(UUID().uuidString)
            }
        }
        .ignoresSafeArea()
        .task {
            await viewModel.fetchRecipeDetails()
        }
    }
    
    var content: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(output.label)
                    .bold()
                    .font(.title2)
                    .multilineTextAlignment(.center)
                
                Text(output.source)
                    .bold()
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
                        
            VStack(alignment: .leading, spacing: 20) {
                if let details = output.details {
                    makeIngredientsView(details.ingredientLines)
                    
                    makeNutrientsView(details)
                    
                } else {
                    switch viewModel.requestState {
                    case .inFlight:
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    case .error(let description):
                        Text(description)
                            .bold()
                            .foregroundStyle(.red)
                    case .none:
                        EmptyView()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .animation(.easeIn, value: viewModel.recipe)
        .animation(.easeIn, value: viewModel.requestState)
    }
    
    func makeIngredientsView(_ ingredients: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(ingredients.count) Ingredients")
                .bold()
                .font(.headline)
                .fontDesign(.serif)
                .foregroundStyle(.gray)
            Divider()
            ForEach(ingredients, id: \.self) { ingredient in
                Text(ingredient)
                    .font(.footnote)
            }
        }
    }
    
    func makeNutrientsView(_ details: RecipeDetails.Details) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nutrition")
                .bold()
                .font(.headline)
                .fontDesign(.serif)
                .foregroundStyle(.gray)
            Divider()
            HStack {
                ForEach(details.nutritionItems, id: \.label) { item in
                    VStack(spacing: 12) {
                        Text(item.value)
                            .font(.callout)
                        Text(item.label)
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
            Divider()
            Text(details.nutritionTags)
                .multilineTextAlignment(.center)
                .font(.title3)
                .bold()
                .foregroundStyle(.gray)
        }
    }
    
    var imageView: some View {
        AsyncImage(
            url: output.imageUrl,
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
    }
}

#Preview("Details") {
    RecipeDetailsView(viewModel: .init(recipe: .mock(details: .mock)))
}

#Preview("Loading") {
    RecipeDetailsView(viewModel: .init(recipe: .mock()))
}

#Preview("Error") {
    RecipeDetailsView(
        viewModel: withDependencies {
            $0.apiClient.fetchRecipeDetails = { _ in
                throw NSError(domain: "Test", code: 500)
            }
        } operation: {
            .init(recipe: .mock(), requestState: .error(description: "An Errro Occurred!"))
        }
    )
}
