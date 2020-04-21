//
//  Ball.swift
//  bonq
//
//  Created by Andrew Tokeley on 10/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import SpriteKit

class Ball: SKShapeNode {
    
    var radius: CGFloat
    
    // MARK: - SubViews
    
    lazy var ball: SKShapeNode = {
        let ball = SKShapeNode(circleOfRadius: self.radius )
        ball.lineWidth = 0
        ball.fillColor = SKColor.app_buttonBackground
        return ball
    }()
    
    // MARK: - Initializers
    
    init(radius: CGFloat) {
        
        self.radius = radius
        super.init()
        
        self.name = NodeNames.ball
        
        self.addChild(ball)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.radius)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 1
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.angularDamping = 0
        self.physicsBody?.isDynamic = true
        
        // Collision stuff
        
        // Identifies the node as being a ball
        self.physicsBody?.category = .ball
        
        // Balls should collide (not overlap) with bats, walls and ground
        //self.physicsBody?.collisionBitMask = PhysicsCategory.bat.rawValue | PhysicsCategory.ground.rawValue
        
        // Only notify when the ball collides with a bat and ground (not walls)
        self.physicsBody?.contactTestBitMask = PhysicsCategory.bat.rawValue | PhysicsCategory.ground.rawValue
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Movement
    
    func movementVector() -> CGVector {
        return self.physicsBody?.velocity ?? CGVector()
    }
    
    func dropInRandomAngle() {
        let speed:Double = 10
        let degrees = Double.random(in: 200 ..< 335)
        //print("degrees: \(degrees)")
        let radians = degrees * Double.pi/180.0
        let vector = CGVector(dx: cos(radians)*speed, dy: sin(radians)*speed)
        //print("vector: \(vector)")
        self.physicsBody?.velocity = CGVector(dx: 0, dy:0) // stop first
        self.physicsBody?.applyImpulse(vector)
    }
    
    func destroy() {
        if let explosion = SKEmitterNode(fileNamed: "SmokeExplosion") {
            explosion.position = CGPoint(x: self.position.x, y: self.position.y - 20)
            explosion.numParticlesToEmit = 10
            ball.scene?.addChild(explosion)
        }
        self.removeFromParent()
    }
    
    func nudge() {
        
    }
}
