//
//  RecipeViewModel.swift
//  MyPantry
//
//  Created by Isha Singhal on 3/30/25.
//

import Foundation
import FirebaseFirestore

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    private let db = Firestore.firestore()

    init() {
        fetchRecipes()
    }

    // Fetch recipes from Firestore
    func fetchRecipes() {
        db.collection("recipes").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching recipes: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.recipes = documents.compactMap { doc -> Recipe? in
                try? doc.data(as: Recipe.self)
            }
        }
    }

    // Add new recipe
    func addRecipe(_ recipe: Recipe) {
        do {
            try db.collection("recipes").addDocument(from: recipe)
        } catch {
            print("❌ Error adding recipe: \(error)")
        }
    }

    // Update existing recipe
    func updateRecipe(_ recipe: Recipe) {
        guard let recipeId = recipe.id else {
            print("❌ Cannot update recipe — missing Firestore document ID")
            return
        }

        do {
            try db.collection("recipes").document(recipeId).setData(from: recipe, merge: true)
            print("✅ Updated recipe: \(recipe.name)")
        } catch {
            print("❌ Error updating recipe: \(error)")
        }
    }

    // Delete a recipe
    func deleteRecipe(_ recipe: Recipe) {
        guard let recipeId = recipe.id else {
            print("❌ Cannot delete recipe — missing Firestore document ID")
            return
        }

        db.collection("recipes").document(recipeId).delete { error in
            if let error = error {
                print("❌ Error deleting recipe: \(error.localizedDescription)")
            } else {
                print("🗑️ Deleted recipe: \(recipe.name)")
            }
        }
    }
}
