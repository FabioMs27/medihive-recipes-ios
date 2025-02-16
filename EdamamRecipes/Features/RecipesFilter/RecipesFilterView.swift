//
//  RecipesFilterView.swift
//  EdamamRecipes
//
//  Created by Fábio Maciel de Sousa on 29.09.2024.
//

import SwiftUI
import ComposableArchitecture

struct RecipesFilterView: View {
    let store: StoreOf<RecipesFilterFeature>
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100), spacing: 4, alignment: .topLeading)
    ]
    
    var body: some View {
        ScrollView {
            content
        }
    }
    
    var content: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Filter Search")
                    .bold()
                
                Spacer()
                
                Button {
                    store.send(.applyFilterTapped)
                } label: {
                    Text("Done")
                }
                .foregroundStyle(Color.white)
                .padding(8)
                .background(Color.green)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Health")
                    .bold()
                LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                    ForEach(RecipesFilter.Settings.HealthOptions.allCases, id: \.rawValue) { option in
                        Button {
                            store.send(.toggleFilterOptionTapped(.health(option)))
                        } label: {
                            makeFilterOption(
                                text: option.displayText,
                                isSelected: store.filterSettings.healthOptions.contains(option)
                            )
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Diet")
                    .bold()
                LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                    ForEach(RecipesFilter.Settings.DietOptions.allCases, id: \.rawValue) { option in
                        Button {
                            store.send(.toggleFilterOptionTapped(.diet(option)))
                        } label: {
                            makeFilterOption(
                                text: option.displayText,
                                isSelected: store.filterSettings.dietOptions.contains(option)
                            )
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
    
    func makeFilterOption(text: String, isSelected: Bool) -> some View {
        Text(text)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .foregroundStyle(isSelected ? .white : .green)
            .background {
                if isSelected {
                    Color.green
                }
            }
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.green, lineWidth: 1)
            )
            
    }
}

#Preview {
    VStack {
        Text("Recipes")
    }
    .sheet(isPresented: .constant(true)) {
        RecipesFilterView.init(
            store: Store(initialState: RecipesFilterFeature.State()) {
                RecipesFilterFeature()
            }
        )
        .presentationDetents([.medium])
    }
}
