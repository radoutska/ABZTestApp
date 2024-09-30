//
//  RadioButton.swift
//  ABZTest
//
//  Created by Anna Radoutska on 28.09.2024.
//

import SwiftUI

struct RadioButtonGroup: View {
    private let theme = AppTheme.shared
    @Binding var selectedPosition: Int?
    @EnvironmentObject var viewModel: MainViewModel
    
    private enum Constants {
        static let titleText = "Select your position"
        static let titleBottomPadding = 12.0
        static let sideSpacing = 12.0
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(Constants.titleText)
                .foregroundStyle(.black.opacity(0.87))
                .font(theme.typography.body2)
                .padding(.bottom, Constants.titleBottomPadding)
            ForEach(viewModel.positions, id: \.self) { position in
                HStack {
                    Image(selectedPosition == position.id ? "radio_button_filled" : "radio_button_empty")
                        .foregroundStyle(theme.colors.secondary)
                    Text(position.name)
                        .foregroundStyle(.black.opacity(0.87))
                        .font(theme.typography.body2)
                        .padding(.leading, Constants.sideSpacing)
                }
                .onTapGesture {
                    selectedPosition = position.id
                }
                .padding(Constants.sideSpacing)
            }
        }
        .onAppear {
            viewModel.fetchPositions()
        }
        .padding(.vertical, 10)
    }
}
