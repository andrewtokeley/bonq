//
//  Spinner.swift
//  bonq
//
//  Created by Andrew Tokeley on 7/05/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import SpriteKit

class Spinner: SKSpriteNode {
    
    init(diameter: CGFloat) {
        let size = CGSize(width: diameter, height: diameter)
        if let image = UIImage(named: "Spinner") {
            super.init(texture: SKTexture(image:image), color: .app_buttonBackground, size: size)
        } else {
            super.init(texture: nil, color: .clear, size: size)
        }

        self.name = NodeNames.spinner
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: diameter/2)
        self.physicsBody?.isDynamic = false
        
        // A spinner is a type of obstacle
        self.physicsBody?.category = [.obstacle]
        
        // Nothing will collide with an obstacle, the ball will float over it
        self.physicsBody?.collisionBitMask = 0
        
        // we want to be notified when a ball contacts the spinner
        self.physicsBody?.contactTestBitMask = PhysicsCategory.ball.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startSpin() {
        let rotate = SKAction.rotate(byAngle: 2, duration: 2)
        self.run(SKAction.repeatForever(rotate))
    }
    
    func stopSpin() {
        self.removeAllActions()
    }
    
    private func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0) -> UIBezierPath {
        let path = UIBezierPath()
        let theta: CGFloat = Math.TWOPI / CGFloat(sides) // How much to turn at every corner
//        let offset: CGFloat = cornerRadius * tan(theta / 2.0)     // Offset from which to start rounding corners
        let width = min(rect.size.width, rect.size.height)        // Width of the square

        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)

        // Radius of the circle that encircles the polygon
        // Notice that the radius is adjusted for the corners, that way the largest outer
        // dimension of the resulting shape is always exactly the width - linewidth
        let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0

        // Start drawing at a point, which by default is at the right hand edge
        // but can be offset
        var angle = CGFloat(rotationOffset)

        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle),y: center.y + (radius - cornerRadius) * sin(angle))
        path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta),y: corner.y + cornerRadius * sin(angle + theta)))

        for _ in 0..<sides {
            angle += theta

            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle),y:  center.y + (radius - cornerRadius) * sin(angle))
            let tip = CGPoint(x: center.x + radius * cos(angle),y: center.y + radius * sin(angle))
            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta),y:  corner.y + cornerRadius * sin(angle - theta))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))

            path.addLine(to: start)
            path.addQuadCurve(to: end, controlPoint: tip)
        }

        path.close()

        // Move the path to the correct origins
        let bounds = path.bounds
        let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0, y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
        path.apply(transform)

        return path
    }
}
