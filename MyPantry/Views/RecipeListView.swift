//
//  SwiftUIView.swift
//  MyPantry
//
//  Created by Isha Singhal on 3/31/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject var viewModel = RecipeViewModel()
    @State private var showAddRecipe = false
    @State private var showManageCats = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.recipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe, viewModel: viewModel)) {
                        Text(recipe.name)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let recipe = viewModel.recipes[index]
                        viewModel.deleteRecipe(recipe)
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                Button(action: { showAddRecipe = true }) {
                    Image(systemName: "plus")
                }
                Button { showManageCats = true } label: { Image(systemName: "tag") }
            }
            .sheet(isPresented: $showAddRecipe) {
                AddRecipeView(viewModel: viewModel)
            }
            .sheet(isPresented: $showManageCats) {
              ManageCategoriesView()
            }
        }
    }
}
