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
    
    private let GROUND_HEIGHT: CGFloat = 10
    
    var gameSceneDelegate: GameSceneDelegate?
    
    /**
     Tracks whether the scene is in a serving state with the ball ready to be served.
     */
    var isServing: Bool = false
    
    /**
     The ball. Note the ball instance will always exist but may be invisible (alpha = 0) if the ball is on the opponent's screen.
     */
    var ball: Ball = Ball(radius: 15)
    
    /**
     The bat the user uses to hit the ball back.
    */
    var bat = Bat(size: CGSize(width: 100, height: 15))
    
    var spinner = Spinner(diameter: 40)
    
    /**
     Set up the scene
     */
    override func didMove(to view: SKView) {
        super.didMove(to:view)
        
        self.backgroundColor = .app_backgroundDark
        self.scaleMode = .aspectFit
        
        // put a wall edge around the whole scene to make sure the ball stays within bounds. Create space at the top of the screen so the ball won't hit it until it's out of sight. This will be the queue to make the ball appear in the opponent's screen.
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height + ball.radius * 2))
        self.physicsBody?.category = .wall
        self.name = NodeNames.wall
        
        // no gravity here, the ball will be able to float around as if in space if it gets a nudge
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        // notify this class of contacts between nodes
        self.physicsWorld.contactDelegate = self
        
        // add ground for balls to crash into
        let ground = Ground(rect: CGRect(x: 0, y: 0, width: self.frame.width, height: GROUND_HEIGHT), fillColour: SKColor.app_buttonBackground)
        self.addChild(ground)
        
        // add bat at the bottom of the screen
        bat.position = CGPoint(x: self.frame.width/2, y: GROUND_HEIGHT + Layout.spacerSmall + bat.size.height)
        self.addChild(bat)

        // add spinner
        spinner.position = CGPoint(x: self.frame.width/2, y: 0.8 * self.frame.height)
        spinner.startSpin()
        self.addChild(spinner)
        
        // add the ball in the serve position, but hide it initally but position it somewhere it won't immediately collide with something. For example, if we didn't set the position it would default to (0, 0) which is over the ground and we'd get a collision event.
        ball.alpha = 0
        ball.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        self.addChild(ball)
    }
    
    deinit {
        print("deinit called")
    }
    
    // MARK: Ball Functions
    
    func moveBallIntoScene(xLocation: CGFloat, vector: CGVector) {
        
        if ball.scene == nil {
            self.addChild(ball)
        }
        ball.alpha = 1  
        ball.position = CGPoint(x: xLocation, y: self.frame.height)
        ball.applyImpulse(normalisedDirectionVector: vector.normalized())
        
    }
    
    func prepareBallForServe() {
        // make sure it's not moving
        
        if ball.scene == nil {
            scene?.addChild(ball)
        }
        ball.removeAllActions()
        ball.alpha = 1
        ball.position = CGPoint(x: bat.position.x, y: bat.position.y + bat.size.height/2 + ball.radius)
        self.isServing = true
    }
    
    func serve(vector: CGVector) {
        self.isServing = false
        ball.serve(vector: vector)
    }
    
    // MARK: - Events
    
    
    override func update(_ currentTime: TimeInterval) {
        if self.isServing {
            ball.position = CGPoint(x: bat.position.x, y: bat.position.y + bat.size.height/2 + ball.radius)
        }
    }
    
}

//MARK: - SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactCategory: PhysicsCategory = [contact.bodyA.category, contact.bodyB.category]

        if contactCategory.contains(.wall) {
            
            // check if this is the top wall
            if ball.position.y > self.frame.height {
                let vector = CGVector(dx: ball.physicsBody!.velocity.dx, dy: ball.physicsBody!.velocity.dy * -1)
                gameSceneDelegate?.gameScene(self, ballLeftScreenAtLocation: ball.position.x, vector: vector)
            } else {
                // TODO: sound of ball against wall
            }
            
        } else if contactCategory.contains(.bat) {
            
            // when you're serving the ball and bat do actually collide, but we don't want to raise this here.
            if !isServing {
                // TODO: make sound
                
                // calculate where along the bat the ball hit. 0 means at the far left, 1 means far right, 0.5 in the middle...
                let p = (contact.contactPoint.x - (bat.position.x - 0.5 * bat.size.width))/bat.size.width
                
                // let the delegate know the ball hit the bat
                gameSceneDelegate?.gameScene(self, ballHitBatAt: p)
            }
            
        } else if contactCategory.contains(.ground) {
            
            // this ball is toast
            ball.destroy()
            
            gameSceneDelegate?.gameScene(self, ballHitGroundAt: contact.contactPoint.x)

        } else if contactCategory.contains(.obstacle) {
            
            // find the ball and obstacle
            if let ball = contact.bodyA.node as? Ball ?? contact.bodyB.node as? Ball {
                
                // for now only recognise contact if the ball is moving towards the other player (as opposed to the ball hitting the other person's spinner)
                if (ball.physicsBody?.velocity.dy ?? 0) > 0 {
                    
                    if let spinner = contact.bodyA.node as? Spinner ?? contact.bodyB.node as? Spinner {
                
                        // suck the ball into the spinner object and fling it out at a random angle
                        ball.run(SKAction.move(to: spinner.position, duration: 1)) {
                            let spinDirection = CGVector(randomAngleBetween: -45, offSet: 90, coordinateSystem: .cartesian)
                            ball.volley(vector: spinDirection, speed: 40)
                        }
                    }
                }
            }
        }
    }
}
