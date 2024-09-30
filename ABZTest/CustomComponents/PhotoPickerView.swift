//
//  PhotoPickerView.swift
//  ABZTest
//
//  Created by Anna Radoutska on 28.09.2024.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @State private var isShowingActionSheet = false
    @State private var selectedSource: PhotoSource?
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    private let theme = AppTheme.shared
    
    enum PhotoSource {
        case camera, gallery
    }
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 200)
                    .overlay(Text("No Image Selected").foregroundColor(.white))
            }
            Button(action: {
                isShowingActionSheet = true
            }, label: {
                Text("Upload Photo")
                    .font(theme.typography.body1)
            })
            .actionSheet(isPresented: $isShowingActionSheet) {
                ActionSheet(
                    title: Text("Choose how you want to add a photo"),
                    buttons: [
                        .default(Text("Camera")) {
                            selectedSource = .camera
                            isShowingImagePicker = true
                        },
                        .default(Text("Gallery")) {
                            selectedSource = .gallery
                            isShowingImagePicker = true
                        },
                        .cancel()
                    ]
                )
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(sourceType: selectedSource == .camera ? .camera : .photoLibrary, selectedImage: $selectedImage)
        }
    }
}


#Preview {
    PhotoPickerView()
}
