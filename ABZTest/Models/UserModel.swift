//
//  UserModel.swift
//  ABZTest
//
//  Created by Anna Radoutska on 27.09.2024.
//

import Foundation
import SwiftUI

struct User: Codable, Identifiable {
    let id: Int?
    let name: String
    let email: String
    let phone: String
    let position: String?
    let positionID: Int
    let photo: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case phone
        case position
        case positionID = "position_id"
        case photo
    }
    
    init(name: String, email: String, phone: String, positionID: Int, photo: String) {
        self.name = name
        self.email = email
        self.phone = phone
        self.positionID = positionID
        self.photo = photo
        self.id = nil
        self.position = nil
    }
}
