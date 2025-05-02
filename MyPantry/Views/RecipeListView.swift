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
    @StateObject var categoryViewModel = CategoryViewModel()
    @State private var showAddRecipe = false
    @State private var showManageCats = false
    @State private var showReport = false
    @State private var sortOption: SortOption = .name
    @State private var selectedCategoryID: String? = nil

    var body: some View {
        let filtered = viewModel.recipes.filter { recipe in
            // if nil, show all; else match
            guard let sel = selectedCategoryID else { return true }
            return recipe.categoryID == sel
        }
        let sortedRecipes: [Recipe] = {
            switch sortOption {
            case .name:
                return filtered.sorted { $0.name.lowercased() < $1.name.lowercased() }
            case .prep:
                return filtered.sorted { $0.prepTime < $1.prepTime }
            case .cook:
                return filtered.sorted { $0.cookTime < $1.cookTime }
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
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        // “All” chip
                        Button("All") { selectedCategoryID = nil }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(selectedCategoryID == nil ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.2))
                            .cornerRadius(12)

                        // One chip per category
                        ForEach(categoryViewModel.categories) { category in
                            Button(category.name) {
                                selectedCategoryID = category.id
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(selectedCategoryID == category.id ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.2))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 4)
                }
                
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
                    Button { showManageCats = true } label: { Image(systemName: "tag")
                    }
                    Button(action: { showAddRecipe = true }) {
                        Image(systemName: "plus")
                    }
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
