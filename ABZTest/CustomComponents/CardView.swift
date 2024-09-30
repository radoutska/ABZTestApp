//
//  CardView.swift
//  ABZTest
//
//  Created by Anna Radoutska on 28.09.2024.
//

import SwiftUI

struct CardView: View {
    private let theme = AppTheme.shared
    let user: FullUserModel
    
    private enum Constants {
        static let verticalSpacing = 16.0
        static let imageSize = 50.0
        static let mainInfoSpacing = 4.0
        static let greyOpacity = 0.48
        static let topPadding = 8.0
        static let lineLimit = 1
        static let verticalPadding = 24.0
    }
    
    init(user: FullUserModel) {
        self.user = user
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: Constants.verticalSpacing) {
            Image(uiImage: user.photo)
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: Constants.mainInfoSpacing) {
                Text(user.user.name)
                    .font(theme.typography.body2)
                Text(user.user.position ?? "")
                    .font(theme.typography.body3)
                    .foregroundStyle(.black.opacity(Constants.greyOpacity))
                Text(user.user.email)
                    .font(theme.typography.body3)
                    .padding(.top, Constants.topPadding)
                    .lineLimit(Constants.lineLimit)
                Text(formatPhoneNumber(user.user.phone))
                    .font(theme.typography.body3)
            }
        }
        .padding(.top, Constants.verticalPadding)
        .padding(.bottom, Constants.verticalPadding)
    }
    
    private func formatPhoneNumber(_ number: String) -> String {
        let cleanedNumber = number.filter { "0123456789".contains($0) }
        // Check if it has the expected length
        guard cleanedNumber.count == 12 else {
            return ""
        }
        
        // Get the indices for slicing
        let startIndex = cleanedNumber.startIndex
        let secondIndex = cleanedNumber.index(startIndex, offsetBy: 2)
        let thirdIndex = cleanedNumber.index(startIndex, offsetBy: 5)
        let fourthIndex = cleanedNumber.index(startIndex, offsetBy: 8)
        let fifthIndex = cleanedNumber.index(startIndex, offsetBy: 10)
        
        let formattedNumber = "+\(cleanedNumber[startIndex..<secondIndex]) " +  // +38
        "(\(cleanedNumber[secondIndex..<thirdIndex])) " +   // (098)
        "\(cleanedNumber[thirdIndex..<fourthIndex]) " +     // 278
        "\(cleanedNumber[fourthIndex..<fifthIndex]) " +    // 76
        "\(cleanedNumber[fifthIndex..<cleanedNumber.endIndex])" // 24
        
        return formattedNumber
    }
}
