//
//  ContentView.swift
//  ABZTest
//
//  Created by Anna Radoutska on 25.09.2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: MainViewModel
    private var networkMonitor: NetworkMonitor
    @State var isConnected: Bool = true
    private var theme = AppTheme.shared
    
    init(networkMonitor: NetworkMonitor) {
        self.networkMonitor = networkMonitor
    }
    
    var body: some View {
        if !networkMonitor.isConnected {
            VStack(spacing: 24) {
                Image("no_connection_image")
                Text("There is no internet connection")
                    .font(theme.typography.header)
                PrimaryButton(text: "Try again") {
                    isConnected = networkMonitor.execute()
                }
            }
        } else {
            TabView {
                UsersView()
                    .tabItem {
                        Text("Users")
                            .font(theme.typography.body1)
                        Image(systemName: "person.3.sequence.fill")
                    }
                
                SignUpForm()
                    .tabItem {
                            Text("Sign up")
                                .font(theme.typography.body1)
                            Image(systemName: "person.crop.circle.fill.badge.plus")
                    }
            }
            .tint(theme.colors.secondary)
            .environmentObject(viewModel)
        }
    }
}

#Preview {
    ContentView(networkMonitor: NetworkMonitor())
}
