//
//  RegisteredView.swift
//  ABZTest
//
//  Created by Anna Radoutska on 29.09.2024.
//

import SwiftUI

struct RegisteredView: View {
    @Environment(\.dismiss) var dismiss
    var isSuccess: Bool
    var message: String
    
    var body: some View {
        VStack(spacing: 24) {
            Image(isSuccess ? "singin_success" : "signin_fail")
            Text(message)
                .font(AppTheme.shared.typography.body2)
            PrimaryButton(text: isSuccess ? "Got it" : "Try again") {
                dismiss()
            }
        }
    }
}

#Preview {
    RegisteredView(isSuccess: true, message: "")
}
