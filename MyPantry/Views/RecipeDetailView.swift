import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var showEdit = false
    @State private var showDeleteConfirmation = false
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(recipe.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 4)

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "timer")
                            Text("Prep Time:")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(recipe.prepTime) mins")
                        }

                        HStack {
                            Image(systemName: "flame")
                            Text("Cook Time:")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(recipe.cookTime) mins")
                        }
                    }
                    .font(.body)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ingredients")
                            .font(.title3)
                            .fontWeight(.semibold)

                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 6, height: 6)
                                    .padding(.top, 6)
                                Text(ingredient)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Steps")
                            .font(.title3)
                            .fontWeight(.semibold)

                        ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 8) {
                                Text("\(index + 1).")
                                    .fontWeight(.bold)
                                Text(step)
                            }
                        }
                    }

                    Spacer(minLength: 50)
                }
                .padding()
            }

            // ✅ Delete button at bottom (always visible)
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                Label("Delete Recipe", systemImage: "trash")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                    .padding([.horizontal, .bottom])
            }
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showEdit = true
                }
            }
        }
        .confirmationDialog(
            "Are you sure you want to delete this recipe?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                viewModel.deleteRecipe(recipe)
                presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showEdit) {
            AddRecipeView(viewModel: viewModel, recipeToEdit: recipe)
        }
    }
}
