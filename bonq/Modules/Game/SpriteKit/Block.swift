//
//  Ground.swift
//  bonq
//
//  Created by Andrew Tokeley on 12/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import SpriteKit

class Block: SKShapeNode {
    
    init(rect: CGRect, fillColour: SKColor) {
        super.init()
        
        self.name = NodeNames.ground
        
        self.path = CGPath(rect: rect, transform: nil)
        self.fillColor = fillColour
        self.lineWidth = 0
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class Wall: Block {
    
    override init(rect: CGRect, fillColour: UIColor) {
        super.init(rect: rect, fillColour: fillColour)
        
        self.name = NodeNames.wall
        self.physicsBody?.category = .wall
        //self.physicsBody?.contactTestBitMask = PhysicsCategory.ball.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Ground: Block {
    
    override init(rect: CGRect, fillColour: UIColor) {
        super.init(rect: rect, fillColour: fillColour)
        
        self.name = NodeNames.ground
        self.physicsBody?.category = .ground
        //self.physicsBody?.contactTestBitMask = PhysicsCategory.ball.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
