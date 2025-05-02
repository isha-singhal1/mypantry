//
//  CategoryViewModel.swift
//  MyPantry
//
//  Created by Isha Singhal on 5/2/25.
//

import Foundation
import FirebaseFirestore

class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    private let db = Firestore.firestore()

    init() {
        fetchCategories()
    }

    func fetchCategories() {
        db.collection("categories").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching categories: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.categories = snapshot?.documents.compactMap {
                try? $0.data(as: Category.self)
            } ?? []
        }
    }

    func addCategory(name: String) {
        let newCategory = Category(name: name)
        do {
            _ = try db.collection("categories").addDocument(from: newCategory)
        } catch {
            print("Error adding category: \(error.localizedDescription)")
        }
    }
    
    func updateCategory(_ category: Category) {
        guard let id = category.id else { return }
        try? db.collection("categories").document(id).setData(from: category, merge: true)
    }

    func deleteCategory(_ category: Category) {
        guard let id = category.id else { return }
        db.collection("categories").document(id).delete()
    }
}
