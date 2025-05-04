//
//  ManageCategoriesView.swift
//  MyPantry
//
//  Created by Isha Singhal on 5/2/25.
//

import SwiftUI

struct ManageCategoriesView: View {
    @StateObject private var vm = CategoryViewModel()
    @State private var showAdd = false
    @State private var editCategory: Category?

    var body: some View {
        NavigationView {
            List {
                ForEach(vm.categories) { cat in
                    HStack {
                        Text(cat.name)
                        Spacer()
                        Button("Edit") {
                            editCategory = cat
                        }
                    }
                }
                .onDelete { idx in
                    idx.map { vm.categories[$0] }.forEach(vm.deleteCategory)
                }
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAdd = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                CategoryEditView(vm: vm)
            }
            .sheet(item: $editCategory) { cat in
                CategoryEditView(vm: vm, categoryToEdit: cat)
            }
        }
    }
}

#Preview {
    ManageCategoriesView()
}
