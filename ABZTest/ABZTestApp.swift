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
    @State private var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            ContentView(networkMonitor: networkMonitor)
                .environmentObject(viewModel)
        }
    }
    
    init() {}
}
