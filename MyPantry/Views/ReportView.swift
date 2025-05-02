//
//  ReportView.swift
//  MyPantry
//
//  Created by Isha Singhal on 5/2/25.
//

import SwiftUI

struct ReportView: View {
    @StateObject private var viewModel = RecipeViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Text("Recipe Report")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Total Recipes: \(viewModel.recipes.count)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                List {
                    ForEach(viewModel.recipes) { recipe in
                        HStack {
                            // Recipe title
                            Text(recipe.name)
                                .font(.headline)
                            
                            Spacer()
                            
                            // Both times in a trailing VStack
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("Prep: \(recipe.prepTime) min")
                                    .font(.subheadline)
                                Text("Cook: \(recipe.cookTime) min")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .padding(.top)   // give a little breathing room under nav bar
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//struct ReportView: View {
//    @StateObject private var viewModel = RecipeViewModel()
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Aggregate metric
//                Text("Total Recipes: \(viewModel.recipes.count)")
//                    .font(.headline)
//                    .padding()
//
//                // Detailed list
//                List(viewModel.recipes) { recipe in
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text(recipe.name)
//                            .font(.title3)
//                            .fontWeight(.semibold)
//                        HStack {
//                            Text("Prep: \(recipe.prepTime) min")
//                            Spacer()
//                            Text("Cook: \(recipe.cookTime) min")
//                        }
//                        .font(.subheadline)
//                    }
//                    .padding(.vertical, 4)
//                }
//                .listStyle(PlainListStyle())
//            }
//            .navigationTitle("Recipe Report")
//        }
//    }
//}

#Preview {
    ReportView()
}
