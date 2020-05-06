//
//  Command.swift
//  bonq
//
//  Created by Andrew Tokeley on 21/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import CoreGraphics

class ProfileUpdateMessage: NSObject, NSCoding {
    /**
     The name of your opponent
     */
    var name: String!
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.name = (decoder.decodeObject(forKey: "name") as! String)
    }
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
    }
        
}


class ScoreMessage: NSObject, NSCoding {
    
    /**
     The score the recipient of this message should get
     */
    var score: Int!
    
    /**
     The score of the recipient's opponent
     */
    var opponentScore: Int!
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.score = (decoder.decodeObject(forKey: "score") as! Int)
        self.opponentScore = (decoder.decodeObject(forKey: "opponentScore") as! Int)
    }
    
    convenience init(score: Int, opponentScore: Int) {
        self.init()
        self.score = score
        self.opponentScore = opponentScore
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(score, forKey: "score")
        coder.encode(opponentScore, forKey: "opponentScore")
    }
    
}

class BallExitMessage: NSObject, NSCoding  {
    
    /**
     The direction vector the ball is leaving a player's screen. Note vectors will be normalised to ensure a consistent speed throughout the game.
     */
    var vector: CGVector!
    
    /**
     A value between 0.0 and 1.0 describing the propotion of the width where the ball is leaving the screen. For example, if the value is 0.5 the ball is leaving half way across the screen.
     */
    var widthProportion: CGFloat!
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        let dx = (decoder.decodeObject(forKey: "dx") as! CGFloat)
        let dy = (decoder.decodeObject(forKey: "dy") as! CGFloat)
        self.vector = CGVector(dx: dx, dy: dy)
        self.widthProportion = (decoder.decodeObject(forKey: "widthProportion") as! CGFloat)
    }
    
    convenience init(widthProportion: CGFloat, vector: CGVector) {
        self.init()
        self.vector = vector
        self.widthProportion = widthProportion
    }
    
    func encode(with coder: NSCoder) {
        if let vector = vector {
            coder.encode(vector.dx, forKey: "dx")
            coder.encode(vector.dy, forKey: "dy")
        }
        if let widthProportion = widthProportion { coder.encode(widthProportion, forKey: "widthProportion") }
    }
}
