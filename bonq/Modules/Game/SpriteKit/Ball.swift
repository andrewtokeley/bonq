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
    
    lazy var diagnosticLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.position = CGPoint(x: 0, y: -30)
        node.fontColor = .white
        node.fontSize = 12
        
        return node
    }()
    
    // MARK: - Initializers
    
    init(radius: CGFloat) {
        
        self.radius = radius
        super.init()
        
        self.name = NodeNames.ball
        
        self.addChild(ball)
        //self.addChild(diagnosticLabel)
        
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
        self.physicsBody?.contactTestBitMask = PhysicsCategory.bat.rawValue | PhysicsCategory.ground.rawValue | PhysicsCategory.wall.rawValue
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Movement
    
    /**
     Applies an impulse to the ball in the direction specified by the vector, ensuring a consistent speed. Can optional supply a location from which to place to ball prior to the impulse.
     
     - Parameters
        - normalisedVector: a vector indicating the direction of the impulse. Should be normalised to ensure a constant amount of force is applied resulting from calling vector.normalise()l
        - fromLocation: optional location for the ball to move from, if nil the ball will move from it's current position
     */
    func applyImpulse(normalisedDirectionVector: CGVector, fromPosition position: CGPoint? = nil) {
        
        // just to be safe
        let vector = normalisedDirectionVector.normalized()
        
        // change the ball's position, if specified
        if let position = position {
            ball.position = position
        }
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        let ballSpeed:CGFloat = 10
        
        self.physicsBody?.applyImpulse(vector * ballSpeed)
    }
    
    /**
     Serve the ball (currently always up and right at 45 degree angle)
     */
    func serve(vector: CGVector) {
        self.applyImpulse(normalisedDirectionVector: vector.normalized())
    }
    
    func destroy() {
        if let explosion = SKEmitterNode(fileNamed: "SmokeExplosion") {
            explosion.position = CGPoint(x: self.position.x, y: self.position.y - 20)
            explosion.numParticlesToEmit = 10
            ball.scene?.addChild(explosion)
        }
        self.removeFromParent()
    }
    
}
