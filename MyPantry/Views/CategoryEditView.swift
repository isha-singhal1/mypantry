//
//  CategoryEditView.swift
//  MyPantry
//
//  Created by Isha Singhal on 5/2/25.
//

import SwiftUI

struct CategoryEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: CategoryViewModel
    @State private var name: String
    var categoryToEdit: Category?

    init(vm: CategoryViewModel, categoryToEdit: Category? = nil) {
      self.vm = vm
      self.categoryToEdit = categoryToEdit
      _name = State(initialValue: categoryToEdit?.name ?? "")
    }

    var body: some View {
      NavigationView {
        Form {
          TextField("Category name", text: $name)
        }
        .navigationTitle(categoryToEdit == nil ? "Add Category" : "Edit Category")
        .toolbar {
          ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
              let cat = Category(id: categoryToEdit?.id, name: name)
              if categoryToEdit == nil {
                vm.addCategory(name: name)
              } else {
                vm.updateCategory(cat)
              }
                presentationMode.wrappedValue.dismiss()
            }
            .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
          }
          ToolbarItem(placement: .cancellationAction) {
              Button("Cancel") { presentationMode.wrappedValue.dismiss() }
          }
        }
      }
    }
}

#Preview {
    // CategoryEditView()
}
