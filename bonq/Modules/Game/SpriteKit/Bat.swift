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
    
    // MARK: - SubViews
    
    lazy var bat: SKShapeNode = {
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
    
    func move (_ direction: BatDirection) {
        
        // How far the bat can move left or right, given a bat's position is determined by its centre
        if let sceneWidth = self.scene?.frame.width {
            let leftMostX = self.size.width/2
            let rightMostX = sceneWidth - self.size.width/2

            // duration of movement is proportional to how far away the left or right boundary is. If the bat is on the left boundary then it should to 2 seconds to get to the right. If it's half way then it should take only 1 second.
            var duration: TimeInterval = 0
            let speed: CGFloat = 2.0
            if direction == .right {
                duration = TimeInterval((sceneWidth - self.position.x)/sceneWidth * speed)
            } else if direction == .left {
                duration = TimeInterval(self.position.x/sceneWidth * speed)
            }
            
            if direction == .left {
                let moveToLeftEdge = SKAction.moveTo(x: leftMostX, duration: duration)
                self.removeAllActions()
                self.run(moveToLeftEdge)
            } else if direction == .right {
                let moveToRightEdge = SKAction.moveTo(x: rightMostX, duration: duration)
                self.removeAllActions()
                self.run(moveToRightEdge)
            } else if direction == .stop {
                self.removeAllActions()
            }
        }
    }
}
