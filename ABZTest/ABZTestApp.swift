//
//  ABZTestApp.swift
//  ABZTest
//
//  Created by Anna Radoutska on 25.09.2024.
//

import SwiftUI

@main
struct ABZTestApp: App {
    @StateObject var viewModel: MainViewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
    
    init() {}
}
