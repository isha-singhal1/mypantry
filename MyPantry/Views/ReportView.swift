//
//  ReportView.swift
//  MyPantry
//
//  Created by Isha Singhal on 5/2/25.
//

import SwiftUI

struct ReportView: View {
    @StateObject private var viewModel = RecipeViewModel()
    
    var categoryFilter: String? = nil
    private var recipesToReport: [Recipe] {
        if let filter = categoryFilter {
            return viewModel.recipes.filter { $0.categoryID == filter }
        } else {
            return viewModel.recipes
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Text("Recipe Report 👩🏽‍🍳")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Total Recipes: \(recipesToReport.count)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                List {
                    ForEach(recipesToReport) { recipe in
                        let totaltime = recipe.prepTime + recipe.cookTime
                        let ingredientsCount = recipe.ingredients.count
                        let stepCount = recipe.steps.count
                        
                        let (difficulty, emoji): (String, String) = {
                            switch totaltime {
                            case 0...20:    return ("Easy", "✅")
                            case 21...45:   return ("Medium", "😐")
                            default:        return ("Hard", "🔥")
                            }
                        }()
                        
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
                                Text("Total Time: \(totaltime) min").font(.subheadline)
                                Text("Number of Ingredients: \(ingredientsCount)").font(.subheadline)
                                Text("Number of Steps: \(stepCount)").font(.subheadline)
                                Text("Estimated Difficulty: \(difficulty)\(emoji)").font(.subheadline)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(PlainListStyle())
                
                if !recipesToReport.isEmpty {
                    let cookTimes = recipesToReport.map(\.cookTime)
                    let avgCookTime = cookTimes.reduce(0, +) / cookTimes.count
                    let prepTimes = recipesToReport.map(\.prepTime)
                    let avgPrepTime = prepTimes.reduce(0, +) / prepTimes.count
                    let totalTimes = recipesToReport.map { $0.prepTime + $0.cookTime }
                    let avgTotalTime = totalTimes.reduce(0, +) / totalTimes.count
                    Text("Average Cook Time: \(avgCookTime) min")
                        .font(.headline)
                        .padding(.top, 16)
                    Text("Average Prep Time: \(avgPrepTime) min")
                        .font(.headline)
                    Text("Average Total Time: \(avgTotalTime) min")
                        .font(.headline)
                        .padding(.bottom, 32)
                }
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
