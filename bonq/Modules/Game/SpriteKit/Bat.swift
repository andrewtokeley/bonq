//
//  Bat.swift
//  bonq
//
//  Created by Andrew Tokeley on 10/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import SpriteKit

class Bat: SKShapeNode {
    
    var size: CGSize
    var moveDirection: BatMovement = .stop
    
    // MARK: - SubViews
    
    private lazy var bat: SKShapeNode = {
        let bat = SKShapeNode(rectOf: size)
        bat.lineWidth = 0
        bat.fillColor = SKColor.app_buttonBackground
        
        return bat
    }()
    
    // MARK: - Initializers
    
    init(size: CGSize) {
        self.size = size
        super.init()

        self.name = NodeNames.bat
        
        self.addChild(bat)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.category = [.bat]
        //self.physicsBody?.contactTestBitMask = PhysicsCategory.ball.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Movements
    
    func move (_ direction: BatMovement) {
        
        self.moveDirection = direction
        
        if let sceneWidth = self.scene?.frame.width {
            
            // Determine the furthest left and right the bat can travel
            let leftMostX = self.size.width/2
            let rightMostX = sceneWidth - self.size.width/2

            // to ensure the bat travels at a constant speed, we calculate the duration assuming it takes 2 seconds (speed) for the bat to travel the full width of the screen
            var duration: TimeInterval!
            let speed: CGFloat = 2
            if direction == .right {
                duration = TimeInterval((sceneWidth - self.position.x)/sceneWidth * speed)
            } else if direction == .left {
                duration = TimeInterval(self.position.x/sceneWidth * speed)
            }
            
            if direction == .left {
                self.speed = 1
                let moveToLeftEdge = SKAction.moveTo(x: leftMostX, duration: duration)
                self.removeAllActions()
                self.run(moveToLeftEdge)
            } else if direction == .right {
                self.speed = 1
                let moveToRightEdge = SKAction.moveTo(x: rightMostX, duration: duration)
                self.removeAllActions()
                self.run(moveToRightEdge)
            } else if direction == .stop {
                self.removeAllActions()
            } else if direction == .brake {
                //slow the bat movement down to zero over the space of 0.5 seconds.
                let brake = SKAction.speed(to: 0, duration: 0.1)
                self.run(brake)
            }
        }
    }
}
