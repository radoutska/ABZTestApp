//
//  TextField.swift
//  ABZTest
//
//  Created by Anna Radoutska on 28.09.2024.
//

import SwiftUI

struct CustomTextField: View {
    private enum FieldState {
        case normal
        case focused
        case focusedFilled
        case error
        
        var borderColor: Color {
            switch self {
            case .normal:
                return Color.black.opacity(Constants.greyColorOpacity)
            case .focused, .focusedFilled:
                return AppTheme.shared.colors.secondary
            case .error:
                return Color.red
            }
        }
        
        var placeholderColor: Color {
            switch self {
            case .normal, .focusedFilled:
                return Color.black.opacity(Constants.greyColorOpacity)
            case .focused:
                return AppTheme.shared.colors.secondary
            case .error:
                return Color.red
            }
        }
    }
    
    var placeholder: String
    var isError: Bool = false
    @Binding var text: String
    var errorMessage: String
    var sublabel: String
    
    @State private var fieldState: FieldState = .normal
    @FocusState var isFocused: Bool
    private let theme = AppTheme.shared
    
    private enum Constants {
        static let selectedPlaceholderOffset = -20
        static let cornerRadius = 4.0
        static let sublabelPadding = 12.0
        static let bottonPadding = 2.0
        static let lineWidth = 1.0
        static let greyColorOpacity = 0.48
    }
    
    var body: some View {
        ZStack(alignment: .leadingFirstTextBaseline) {
            Text(placeholder)
                .padding()
                .animation(.easeIn, value: isFocused)
            /// Animation when field is selected
                .font((isFocused || !text.isEmpty) ? theme.typography.bodySmall : theme.typography.body1)
                .foregroundStyle(fieldState.placeholderColor)
                .offset((isFocused || !text.isEmpty) ? CGSize(width: 0, height: Constants.selectedPlaceholderOffset) : CGSize())
            VStack(alignment: .leading, spacing: 5) {
                TextField("", text: $text)
                    .focused($isFocused)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.cornerRadius)
                            .stroke(fieldState.borderColor, lineWidth: Constants.lineWidth)
                            .frame(height: 56)
                    )
                    .frame(height: 56)
                    .padding(.bottom, Constants.bottonPadding)
                    .keyboardType(.numbersAndPunctuation)
                Text(isError ? errorMessage : sublabel)
                    .padding(.leading, Constants.sublabelPadding)
                    .font(AppTheme.shared.typography.bodySmall)
                    .foregroundColor(fieldState.placeholderColor)
            }
        }
        /// To Track when state of field changes and update colors accordingly
        .onChange(of: isError) {
            updateFieldState()
        }
        .onChange(of: isFocused) {
            updateFieldState()
        }
        .onChange(of: text) {
            updateFieldState()
        }
        .onAppear {
            updateFieldState()
        }
    }
    
    private func updateFieldState() {
        if isError {
            fieldState = .error
        } else if isFocused {
            fieldState = text.isEmpty ? .focused : .focusedFilled
        } else {
            fieldState = .normal
        }
    }
}
