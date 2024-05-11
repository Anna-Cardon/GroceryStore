//
//  GroceryStoreApp.swift
//  GroceryStore
//
//  Created by Anna on 4/16/23.
//connects to firebase

import SwiftUI
import FirebaseCore

@main
struct GroceryStoreApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
