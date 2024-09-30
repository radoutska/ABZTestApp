//
//  UsersView.swift
//  ABZTest
//
//  Created by Anna Radoutska on 27.09.2024.
//

import SwiftUI

struct UsersView: View {
    @EnvironmentObject private var viewModel: MainViewModel
    private let theme = AppTheme.shared
    @State private var isLoading = false
    @State private var isFinished = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Working with GET request")
                .font(theme.typography.header)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(theme.colors.primary)
            if viewModel.users.isEmpty {
                Spacer()
                VStack(spacing: 24) {
                    Image("no_users")
                    Text("There are no users yet")
                        .font(theme.typography.header)
                }
                Spacer()
            } else {
                List {
                    ForEach(viewModel.users, id: \.self) { user in
                        CardView(user: user)
                            .padding()
                    }
                    if !isFinished {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .listRowSeparator(.hidden, edges: .all)
                            .tint(.gray)
                            .onAppear {
                                loadMoreContent()
                            }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.trailing, 16)
                .listStyle(PlainListStyle())
                .background(Color.white)
            }
        }
    }
    
    func loadMoreContent() {
        if !isLoading {
            isLoading = true
            viewModel.fetchUsers()
            isLoading = false
        }
    }
}

#Preview {
    UsersView()
}
