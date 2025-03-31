//
//  MyPantryApp.swift
//  MyPantry
//
//  Created by Isha Singhal on 1/21/25.
//

import SwiftUI
import Firebase

@main
struct MyPantryApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
