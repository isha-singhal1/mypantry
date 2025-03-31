//
//  Recipe.swift
//  MyPantry
//
//  Created by Isha Singhal on 3/30/25.
//

import Foundation
import FirebaseFirestore

struct Recipe: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var ingredients: [String]
    var prepTime: Int
    var cookTime: Int
    var steps: [String]
}
