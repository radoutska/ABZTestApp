//
//  AppUIKit.swift
//  ABZTest
//
//  Created by Anna Radoutska on 27.09.2024.
//

import Foundation
import SwiftUI

public struct AppTheme {

    public static let shared = AppTheme()

    public let typography: Typography
    public let colors: Colors
    public let images: Images
    public let icon: Icon
    
    init() {
        self.typography = Typography()
        self.colors = Colors()
        self.images = Images()
        self.icon = Icon()
    }
}

public extension AppTheme {
    struct Typography {
        public let header = Font.custom("NunitoSans", size: 20)
        public let body1 = Font.custom("NunitoSans", size: 16)
        public let body2 = Font.custom("NunitoSans", size: 18)
        public let body3 = Font.custom("NunitoSans", size: 14)
        public let bodySmall = Font.custom("NunitoSans", size: 12)
    }
    
    struct Colors {
        public let primary = Color(hex: "F4E041")
        public let secondary = Color(hex: "00BDD3")
        public let background = Color(hex: "FFFFFF")
        public let grey = Color(hex: "F8F8F8")
        public let lightGrey = Color(hex: "D0CFCF")
        public let middleGrey = Color(hex: "DEDEDE")
        public let pressed = Color(hex: "FFC700")
    }
    
    struct Icon {
        public let users = Image("users_icon")
        public let signIn = Image("signin_icon")
    }
    
    struct Images {
        
    }
}

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}
