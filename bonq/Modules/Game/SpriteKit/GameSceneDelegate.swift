//
//  GameSceneDelegate.swift
//  bonq
//
//  Created by Andrew Tokeley on 12/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import SpriteKit

protocol GameSceneDelegate {
    func gameScene(_ gameScene: SKScene, ballHitBatAt location: CGFloat)
    func gameScene(_ gameScene: SKScene, ballHitGroundAt location: CGFloat)
    func gameScene(_ gameScene: SKScene, ballLeftScreenAtLocation location: CGFloat, vector: CGVector)
    func gameScene(_ gameScene: SKScene, didServiceBallInDirection vector: CGVector)
}
