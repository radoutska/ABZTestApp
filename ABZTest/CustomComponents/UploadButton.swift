//
//  UploadButton.swift
//  ABZTest
//
//  Created by Anna Radoutska on 28.09.2024.
//

import SwiftUI
import PhotosUI

struct UploadButton: View {
    enum PhotoSource {
        case camera, gallery
    }
    
    var label: String
    var isError: Bool = false
    @Binding var selectedImage: UIImage?
    @State private var isShowingActionSheet = false
    @State private var selectedSource: PhotoSource?
    @State private var isShowingImagePicker = false
    
    private enum Constants {
        static let uploadText = "Upload"
        static let chooseText = "Choose how you want to add a photo"
        static let cameraOption = "Camera"
        static let galleryOption = "Gallery"
        static let cornerRadius = 4.0
        static let lineWidth = 1.0
        static let sublabelPadding = 12.0
        static let frameHeight = 56.0
        static let sublabelText = "Photo is required"
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                    .font(AppTheme.shared.typography.body1)
                    .foregroundStyle(isError ? Color.red : Color.black.opacity(0.48))
                Spacer()
                Button(action: {
                    isShowingActionSheet = true
                }) {
                    Text(Constants.uploadText)
                        .font(AppTheme.shared.typography.body1)
                        .foregroundColor(AppTheme.shared.colors.secondary)
                }
                .actionSheet(isPresented: $isShowingActionSheet) {
                    ActionSheet(
                        title: Text(Constants.chooseText),
                        buttons: [
                            .default(Text(Constants.cameraOption)) {
                                selectedSource = .camera
                                isShowingImagePicker = true
                            },
                            .default(Text(Constants.galleryOption)) {
                                selectedSource = .gallery
                                isShowingImagePicker = true
                            },
                            .cancel()
                        ]
                    )
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(isError ? Color.red : Color.black.opacity(0.48), lineWidth: Constants.lineWidth)
                    .frame(height: Constants.frameHeight)
            )

            if isError {
                Text(Constants.sublabelText)
                    .font(AppTheme.shared.typography.bodySmall)
                    .foregroundColor(.red)
                    .padding(.leading, Constants.sublabelPadding)
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(sourceType: selectedSource == .camera ? .camera : .photoLibrary, selectedImage: $selectedImage)
        }
    }
}
