//
//  GameScene.swift
//  bonq
//
//  Created by Andrew Tokeley on 10/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    var gameSceneDelegate: GameSceneDelegate?
    
    var xDelta: Int = 1
    var yDelta: Int = 1
    
    var ball = Ball(radius: 15)
    var bat = Bat(size: CGSize(width: 100, height: 15))
    
    var moveAction: SKAction {
        return SKAction.repeatForever(SKAction.move(by: CGVector(dx: xDelta, dy: yDelta), duration: 0.5))
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to:view)
        
        // make sure no nodes can escape the edges of the scene
        self.backgroundColor = .app_backgroundDark
        self.scaleMode = .aspectFit
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height + 40))
        self.physicsBody?.category = .wall
        self.name = NodeNames.wall
        
        // no gravity here, dynamic objects can float around as if in space
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        // notify this class of contacts
        self.physicsWorld.contactDelegate = self
        
        // add ground
        let ground = Ground(rect: CGRect(x: 0, y: 0, width: self.frame.width, height: 30), fillColour: SKColor.app_buttonBackground)
        self.addChild(ground)
        
        // add the ball and bat
        ball.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addChild(ball)
        bat.position = CGPoint(x: self.frame.width/2, y: 40)
        self.addChild(bat)

        
        // register swipes and tap
        let left = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        left.direction = .left
        self.view?.addGestureRecognizer(left)
        let right = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        right.direction = .right
        self.view?.addGestureRecognizer(right)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.view?.addGestureRecognizer(tap)
        
        respawnBall()
    }
    
    // MARK: Ball Functions
    
    private func respawnBall() {
        
        ball.position = CGPoint(x: CGFloat.random(in: 10 ..< self.frame.width), y: self.frame.height + 10)
        
        if ball.parent == nil {
            scene?.addChild(ball)
        }
        ball.dropInRandomAngle()
        
    }
    
    // MARK: Events
    
    @objc func swipeHandler(sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            bat.move(.left)
        } else {
            bat.move(.right)
        }
    }
    
    @objc func tapHandler(sender: UITapGestureRecognizer) {
        bat.move(.stop)
    }
    
    // MARK: game loop
    override func update(_ currentTime: TimeInterval) {
        let movingUp = ball.movementVector().dy > 0
        let ballOutOfBounds = ball.position.y > self.frame.height
        
        // simulate bouncing back randomly
        if ballOutOfBounds && movingUp {
            ball.position = CGPoint(x: CGFloat.random(in: 10 ..< self.frame.width), y: self.frame.height + 40)
            ball.dropInRandomAngle()
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactCategory: PhysicsCategory = [contact.bodyA.category, contact.bodyB.category]

        if contactCategory.contains(.bat) {
            gameSceneDelegate?.gameScene(self, ballHitBatAt: contact.contactPoint.x)
        } else if contactCategory.contains(.ground) {
            gameSceneDelegate?.gameScene(self, ballHitGroundAt: contact.contactPoint.x)
            
            // smoke it
            ball.destroy()
            self.respawnBall()
        }
    }
}
