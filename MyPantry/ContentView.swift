//
//  ContentView.swift
//  MyPantry
//
//  Created by Isha Singhal on 1/21/25.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

struct ContentView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some View {
        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
            RecipeListView()
            // AddRecipeView(viewModel: RecipeViewModel())
            // Text("Hello world!")
        }
        .padding()
    }
}

#Preview {
    AddRecipeView(viewModel: RecipeViewModel())
}
