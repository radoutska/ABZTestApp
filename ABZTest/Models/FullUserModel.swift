//
//  FullUserModel.swift
//  ABZTest
//
//  Created by Anna Radoutska on 29.09.2024.
//

import Foundation
import SwiftUI

struct FullUserModel {
    var user: User
    var photo: UIImage
}

extension FullUserModel: Identifiable, Hashable {
    static func == (lhs: FullUserModel, rhs: FullUserModel) -> Bool {
        return lhs.user.id == rhs.user.id && lhs.photo == rhs.photo
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(user.id)
        hasher.combine(photo)
    }
    
    var id: String { String(describing: user.id) }
}
