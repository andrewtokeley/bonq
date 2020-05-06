//
//  VectorExtension.swift
//  bonq
//
//  Created by Andrew Tokeley on 27/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import CoreGraphics

enum CoordinateSystem: Int {
    case screen = 0
    case spriteKit
}

extension CGVector {
    
    /**
     The distance between two vectors.
     
     For example, below the distance between the two vectors would be 1.414 ( i.e. sqrt(2) )
     
     ````
        ^ vector(0, -1)
        | \
        |   \   distance
        |     \
        x------> vector(1, 0)
     
     ````
     */
    func distance(fromVector vector: CGVector) -> CGFloat {
        return sqrt(pow(dx - vector.dx, 2) + pow(dy - vector.dy, 2))
    }
    
    var lengthSquared: CGFloat {
        return dx * dx + dy * dy
    }
    
    /**
     The length of a vector.
     
     For example, below the length would be 10.
     
     ````
        
        x------> vector(10, 0)
     
     ````
    */
    var length: CGFloat {
        return sqrt(lengthSquared)
    }
    
    /**
     The inverse of a vector is 180 degrees in the opposite direction.
     
     ````
     
     vector(-1, 0) <------ x ------> vector(1, 0)
     
     ````
    */
    var inverse: CGVector {
        return -self
    }
    
    /**
    Normalises a vector to standard units by dividing both dimensions by the vector length. For example, both (10, 10) and (20, 20) would be normalised to (1,1).
     */
    func normalized() -> CGVector {
        let lengthSquared = self.lengthSquared
        if lengthSquared ~= 0 || lengthSquared ~= 1 {
            return self
        }
        return self / sqrt(lengthSquared)
    }
    
    /**
     Creates a normalised vector with the desired angle relative to horizontal.
     
     - Parameters:
        - angle: angle, in degrees, from vertical. i.e. 90 degree would be a vector (1, 0) in either coordinate system
        - coordinateSystem: specifies whether to assume the y axis increases in an upwards direction (.spritekit) or downwards (.screen)
     */
    init(angle: CGFloat, coordinateSystem: CoordinateSystem) {
        
        let radians = angle / Math.RAD2DEG
        
        let yAdjust: CGFloat = coordinateSystem == .screen ? -1 : 1
        self.init(dx: CGFloat(sinf(Float(radians))), dy: CGFloat(cosf(Float(radians))) * yAdjust)
    }
    
    static prefix func - (v: CGVector) -> CGVector {
        return CGVector(dx: -v.dx, dy: -v.dy)
    }
    
    static func / (lhs: CGVector, rhs: CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
    }
    
    static func / (lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx / rhs.dx, dy: lhs.dy / rhs.dy)
    }
    
    static func * (lhs: CGVector, rhs: CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }
    
    static func * (lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx * rhs.dx, dy: lhs.dy * rhs.dy)
    }
    
    static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }
    
    static func - (lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }

    static func ~= (lhs: CGVector, rhs: CGVector) -> Bool {
        return lhs.dx ~= rhs.dx && lhs.dy ~= rhs.dy
    }
}

