import SwiftUI

struct AddRecipeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: RecipeViewModel

    @State private var name: String = ""
    @State private var ingredients: String = ""
    @State private var prepTime: String = ""
    @State private var cookTime: String = ""
    @State private var steps: String = ""
    
    @StateObject var categoryViewModel = CategoryViewModel()
    @State private var selectedCategoryID: String?
    @State private var newCategoryName: String = ""
    @State private var showAddCategory = false
    
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
            _selectedCategoryID = State(initialValue: recipe.categoryID)
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
                
                Section(header: Text("Category")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(categoryViewModel.categories) { category in
                                Button(action: {
                                    selectedCategoryID = category.id
                                }) {
                                    Text(category.name)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedCategoryID == category.id ? Color.blue.opacity(0.7) : Color.gray.opacity(0.2))
                                        .foregroundColor(.black)
                                        .cornerRadius(16)
                                }
                            }

                            Button(action: {
                                showAddCategory = true
                            }) {
                                Label("Add", systemImage: "plus")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.green.opacity(0.3))
                                    .cornerRadius(16)
                            }
                        }
                        .padding(.vertical, 8)
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
                        steps: cleanedSteps,
                        categoryID: selectedCategoryID
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
            .sheet(isPresented: $showAddCategory) {
                VStack(spacing: 20) {
                    Text("Add New Category")
                        .font(.headline)

                    TextField("Category Name", text: $newCategoryName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Save") {
                        if !newCategoryName.trimmingCharacters(in: .whitespaces).isEmpty {
                            categoryViewModel.addCategory(name: newCategoryName)
                            newCategoryName = ""
                            showAddCategory = false
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}

#Preview {
    AddRecipeView(viewModel: RecipeViewModel())
}
