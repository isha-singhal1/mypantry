import SwiftUI

struct AddRecipeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: RecipeViewModel

    @State private var name: String = ""
    @State private var ingredients: String = ""
    @State private var prepTime: String = ""
    @State private var cookTime: String = ""
    @State private var steps: String = ""

    var recipeToEdit: Recipe?

    init(viewModel: RecipeViewModel, recipeToEdit: Recipe? = nil) {
        self.viewModel = viewModel
        self.recipeToEdit = recipeToEdit

        if let recipe = recipeToEdit {
            _name = State(initialValue: recipe.name)
            _ingredients = State(initialValue: recipe.ingredients.joined(separator: ", "))
            _prepTime = State(initialValue: "\(recipe.prepTime)")
            _cookTime = State(initialValue: "\(recipe.cookTime)")
            _steps = State(initialValue: recipe.steps.joined(separator: ". "))
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details")) {
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("Name", text: $name)
                        TextField("Ingredients (comma separated)", text: $ingredients)
                        TextField("Prep Time (mins)", text: $prepTime)
                            .keyboardType(.numberPad)
                        TextField("Cook Time (mins)", text: $cookTime)
                            .keyboardType(.numberPad)
                        TextField("Steps (separate by period)", text: $steps)
                    }
                }
            }
            .navigationTitle(recipeToEdit == nil ? "Add Recipe" : "Edit Recipe")
            .toolbar {
                Button("Save") {
                    let cleanedIngredients = ingredients.components(separatedBy: ",")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }
                    let cleanedSteps = steps.components(separatedBy: ".")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }

                    let newRecipe = Recipe(
                        id: recipeToEdit?.id ?? UUID().uuidString,
                        name: name,
                        ingredients: cleanedIngredients,
                        prepTime: Int(prepTime) ?? 0,
                        cookTime: Int(cookTime) ?? 0,
                        steps: cleanedSteps
                    )

                    if recipeToEdit == nil {
                        viewModel.addRecipe(newRecipe)
                    } else {
                        viewModel.updateRecipe(newRecipe)
                    }

                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || ingredients.isEmpty || steps.isEmpty)
            }
        }
    }
}

#Preview {
    AddRecipeView(viewModel: RecipeViewModel())
}
