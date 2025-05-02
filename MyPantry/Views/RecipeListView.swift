//
//  SwiftUIView.swift
//  MyPantry
//
//  Created by Isha Singhal on 3/31/25.
//

import SwiftUI

enum SortOption: String, CaseIterable, Identifiable {
    case name = "Name"
    case prep = "Prep Time"
    case cook = "Cook Time"

    var id: String { rawValue }
}

struct RecipeListView: View {
    @StateObject var viewModel = RecipeViewModel()
    @State private var showAddRecipe = false
    @State private var showManageCats = false
    @State private var showReport = false
    @State private var sortOption: SortOption = .name

    var body: some View {
        let sortedRecipes: [Recipe] = {
            switch sortOption {
            case .name:
                return viewModel.recipes
                    .sorted { $0.name.lowercased() < $1.name.lowercased() }
            case .prep:
                return viewModel.recipes
                    .sorted { $0.prepTime < $1.prepTime }
            case .cook:
                return viewModel.recipes
                    .sorted { $0.cookTime < $1.cookTime }
            }
        }()
        NavigationView {
            VStack(spacing: 8) {
                // 2️⃣ Sort Picker only
                Picker("Sort by", selection: $sortOption) {
                    ForEach(SortOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding([.horizontal, .top])
                List {
                    ForEach(sortedRecipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe, viewModel: viewModel)) {
                            Text(recipe.name)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let recipe = sortedRecipes[index]
                            viewModel.deleteRecipe(recipe)
                        }
                    }
                }
                .padding(.top, 4)
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { showReport = true }) {
                        Image(systemName: "doc.text.magnifyingglass")
                    }
                    Button(action: { showAddRecipe = true }) {
                        Image(systemName: "plus")
                    }
                    Button { showManageCats = true } label: { Image(systemName: "tag") }
                }
            }
            .sheet(isPresented: $showAddRecipe) {
                AddRecipeView(viewModel: viewModel)
            }
            .sheet(isPresented: $showManageCats) {
              ManageCategoriesView()
            }
            .sheet(isPresented: $showReport) {
                ReportView()
            }
        }
    }
}
