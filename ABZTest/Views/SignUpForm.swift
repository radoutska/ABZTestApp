//
//  SignUpForm.swift
//  ABZTest
//
//  Created by Anna Radoutska on 28.09.2024.
//

import SwiftUI
import PhotosUI

struct SignUpForm: View {
    private let theme = AppTheme.shared
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var selectedPosition: Int?
    @State private var selectedFile: UIImage?
    @State private var showError: Bool = false
    @State private var registrationResult: (Bool, String) = (false, "")
    @EnvironmentObject var viewModel: MainViewModel
    
    private enum Constants {
        static let headlineText = "Working with POST request"
        static let namePlaceholder = "Your name"
        static let mailPlaceholder = "Email"
        static let phonePlaceholder = "Phone"
        static let requiredError = "Required field"
        static let mailError = "Invalid email format"
        static let photoError = "Upload your photo"
        static let photoSelected = "File selected"
        static let signUpText = "Sign up"
        static let phoneExample = "+38 (XXX) XXX - XX - XX"
    }
    
    /// Validate that at least one field is filled up
    private var isFormValid: Bool {
        return !name.isEmpty ||
        viewModel.isValidEmail(email) ||
        viewModel.isValidUkrainianPhoneNumber(phone) ||
        selectedPosition != nil ||
        selectedFile != nil
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(Constants.headlineText)
                    .font(theme.typography.header)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.colors.primary)
                ScrollView {
                    Spacer()
                        .frame(height: 16)
                    VStack(alignment: .leading, spacing: 16) {
                        CustomTextField(
                            placeholder: Constants.namePlaceholder,
                            isError: showError && name.isEmpty,
                            text: $name,
                            errorMessage: Constants.requiredError,
                            sublabel: ""
                        )
                        CustomTextField(
                            placeholder: Constants.mailPlaceholder,
                            isError: showError && !viewModel.isValidEmail(email),
                            text: $email,
                            errorMessage: Constants.mailError,
                            sublabel: ""
                        )
                        CustomTextField(
                            placeholder: Constants.phonePlaceholder,
                            isError: showError && !viewModel.isValidUkrainianPhoneNumber(phone),
                            text: $phone,
                            errorMessage: Constants.requiredError,
                            sublabel: Constants.phoneExample
                        )
                        RadioButtonGroup(
                            selectedPosition: $selectedPosition
                        )
                        .environmentObject(viewModel)
                        UploadButton(
                            label: (selectedFile != nil) ? Constants.photoSelected : Constants.photoError,
                            isError: showError && selectedFile == nil,
                            selectedImage: $selectedFile
                        )
                    }
                    .padding()
                    Spacer()
                    PrimaryButton(text: Constants.signUpText) {
                        guard let image = selectedFile, !name.isEmpty, viewModel.isValidEmail(email), !phone.isEmpty else {
                            showError = true
                            return
                        }
                        viewModel.registerUser(
                            name: name,
                            email: email,
                            phone: phone,
                            positionId: selectedPosition!,
                            photo: image,
                            completion: { isSuccess, message in
                                registrationResult = (isSuccess, message)
                            }
                        )
                    }
                    /// Button is disabled if form doesn't have at least one field filled up
                    .disabled(!isFormValid)
                    .padding()
                }
                .scrollIndicators(.hidden)
            }
            .navigationDestination(isPresented: $registrationResult.0) {
                RegisteredView(isSuccess: registrationResult.0, message: registrationResult.1)
                    .toolbar(.hidden, for: .tabBar)
                    .toolbar(.hidden, for: .navigationBar)
            }
            .background(theme.colors.background)
        }
    }
}


#Preview {
    SignUpForm()
}
