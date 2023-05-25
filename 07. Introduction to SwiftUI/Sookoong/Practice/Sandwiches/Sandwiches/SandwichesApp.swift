//
//  SandwichesApp.swift
//  Sandwiches
//
//  Created by 전민수 on 2023/05/23.
//

import SwiftUI

@main
struct SandwichesApp: App {
    @StateObject private var store = SandwichStore()

    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
