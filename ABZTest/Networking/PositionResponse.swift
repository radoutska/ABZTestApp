//
//  PositionResponse.swift
//  ABZTest
//
//  Created by Anna Radoutska on 28.09.2024.
//

import Foundation

struct PositionsResponse: Codable {
    let success: Bool
    let positions: [Position]
}
