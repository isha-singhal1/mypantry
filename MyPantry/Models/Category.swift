//
//  Category.swift
//  MyPantry
//
//  Created by Isha Singhal on 5/2/25.
//

import Foundation
import FirebaseFirestore

struct Category: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
}
