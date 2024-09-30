//
//  UserResponse.swift
//  ABZTest
//
//  Created by Anna Radoutska on 27.09.2024.
//

import Foundation

struct UserResponse: Codable {
    let success: Bool
    let totalPages: Int
    let totalUsers: Int
    let count: Int
    let page: Int
    let links: Links
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case success
        case totalPages = "total_pages"
        case totalUsers = "total_users"
        case count
        case page
        case links
        case users
    }
}

struct Links: Codable {
    let nextURL: String?
    let prevURL: String?
    
    enum CodingKeys: String, CodingKey {
        case nextURL = "next_url"
        case prevURL = "prev_url"
    }
}

struct UserCreationResponse: Codable {
    let success: Bool
    let user_id: Int?  // This is only available in a success response
    let message: String
    let fails: ValidationErrors?  // This will be non-nil in a validation failure
}

struct ValidationErrors: Codable {
    let name: [String]?
    let email: [String]?
    let phone: [String]?
    let position_id: [String]?
    let photo: [String]?
}
