//
//  PrimaryButton.swift
//  ABZTest
//
//  Created by Anna Radoutska on 27.09.2024.
//

import SwiftUI

struct PrimaryButton: View {
    @Environment(\.isEnabled) var isEnabled
    let text: String
    let action: (() -> Void)
    private let theme = AppTheme.shared
    
    private enum Constants {
        static let greyOpacity = 0.48
        static let sidePadding = 40.0
        static let verticalPadding = 12.0
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(text)
                    .font(theme.typography.body2)
            }
            .foregroundColor(isEnabled ? Color.black : Color.black.opacity(Constants.greyOpacity))
            .padding([.leading, .trailing], Constants.sidePadding)
            .padding([.top, .bottom], Constants.verticalPadding)
        }
        .buttonStyle(CustomButtonStyle(isEnabled: isEnabled))
    }
}

/// Custom button style
private struct CustomButtonStyle: ButtonStyle {
    private let theme = AppTheme.shared
    let isEnabled: Bool

    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        let backgroundColor = isEnabled ? theme.colors.primary : theme.colors.middleGrey
        let pressedColor = theme.colors.pressed
        let background = configuration.isPressed ? pressedColor : backgroundColor

        configuration.label
            .foregroundColor(.black)
            .background(background)
            .cornerRadius(24)
    }
}

#Preview {
    PrimaryButton(text: "Button") {
        //
    }
}
