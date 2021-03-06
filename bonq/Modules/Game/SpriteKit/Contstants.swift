//
//  SpriteNames.swift
//  bonq
//
//  Created by Andrew Tokeley on 12/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import SpriteKit

struct PhysicsCategory: OptionSet {
    let rawValue: UInt32
    init(rawValue: UInt32) { self.rawValue = rawValue }

    static let bat  = PhysicsCategory(rawValue: 0b00001)
    static let ball = PhysicsCategory(rawValue: 0b00010)
    static let wall = PhysicsCategory(rawValue: 0b00100)
    static let ground = PhysicsCategory(rawValue: 0b01000)
    static let obstacle = PhysicsCategory(rawValue: 0b10000)
}

extension SKPhysicsBody {
    var category: PhysicsCategory {
        get {
            return PhysicsCategory(rawValue: self.categoryBitMask)
        }
        set(newValue) {
            self.categoryBitMask = newValue.rawValue
        }
    }
}

struct NodeNames {
    static let ball = "ball"
    static let bat = "bat"
    static let wall = "wall"
    static let ground = "ground"
    static let spinner = "spinner"
}
