//
//  VectorExtension.swift
//  bonq
//
//  Created by Andrew Tokeley on 27/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import CoreGraphics

/**
 Enumeration to distinguish between to coordinate systems. Some vector extension methods will behave differently depending on whether you're using cartesian or screen coordinates.
 */
enum CoordinateSystem: Int {
    /**
     In a screen coordinate system (used by SpriteKit) the y-axis increases in value as you move down the screen. The x-axis increases as you move to the right. Typically the (0, 0) point is in the top left corner of the screen. This is the system used by UIKit.
     */
    case screen = 0
    
    /**
     In a cartesian coordinate system the y-axis increases in value as you move upwards. The x-axis increases as you move to the right. This is the system used by SpriteKit.
     */
    case cartesian = 1
}

/**
 Extenstions to the CGVector to help with vector maths.
 */
extension CGVector {
    
    /**
     The distance between two vectors.
     
     For example, below the distance between the two vectors would be 1.414 ( i.e. sqrt(2) )
     
     ````
        ^ vector(0, 1)
        | \
        |   \   distance
        |     \
        x------> vector(1, 0)
     
     ````
     - Parameters:
        - vector: the vector from which to calculate the distance.
     */
    func distance(fromVector vector: CGVector) -> CGFloat {
        return sqrt(pow(dx - vector.dx, 2) + pow(dy - vector.dy, 2))
    }
    
    private var magnitudeSquared: CGFloat {
        return dx * dx + dy * dy
    }
    
    /**
     The magnitude, or length, of a vector.
     
     For example, below the magnitude would be 10.
     
     ````
        
        x------> vector(10, 0)
     
     ````
    */
    var magnitude: CGFloat {
        return sqrt(magnitudeSquared)
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
     Dot product between two vectors
     */
    func dot(_ vector: CGVector) -> CGFloat {
        return self.dx * vector.dx + self.dy * vector.dy
    }
    
    /**
     Cross product between two vectors. Typically cross product are used with 3D vectors but in the 2D case you can assume the z dimensions are 0 and the resulting vector would have x and y return 0, hence the only useful number of the z value, rather than the vector result.
     */
    func cross(_ vector: CGVector) -> CGFloat {
        return self.dx * vector.dy - self.dy * vector.dx
    }
    
    /**
     Calculate the angle between two vectors
     
     - Parameters:
        - vector: vector with which to compare self
        - coordinateSystem: coordinate system self and vector are assumed to be in. The default is .cartersian.
     */
    func angleTo(_ vector: CGVector, coordinateSystem: CoordinateSystem = .cartesian) -> CGFloat {
        if self == vector {
            return 0
        }
        
        let t1 = normalized()
        let t2 = vector.normalized()
        let cross = t1.cross(t2)
        let dot = max(-1, min(1, t1.dot(t2)))

        // depending on the coordinate system the result needs to be modified
        let coordinateAdjust: CGFloat = coordinateSystem == .cartesian ? 1 : -1
        
        let result = atan2(cross, dot) * Math.RAD2DEG * coordinateAdjust
        
        return result
    }
    
    /**
    Normalises a vector to standard units by dividing both dimensions by the vector length. For example, both (10, 10) and (20, 20) would be normalised to (1,1).
     */
    func normalized() -> CGVector {
        let magnitudeSquared = self.magnitudeSquared
        if magnitudeSquared == 0 || magnitudeSquared == 1 {
            return self
        }
        return self / sqrt(magnitudeSquared)
    }
    
    /**
     Creates a normalised vector with the desired angle relative to horizontal.
     
     - Parameters:
        - angle: angle, in degrees, from vertical. i.e. 90 degree would be a vector (1, 0) in either coordinate system
        - coordinateSystem: coordinate system self and vector are assumed to be in. The default is .cartersian.
     */
    init(angle: CGFloat, coordinateSystem: CoordinateSystem = .cartesian) {
        
        let radians = angle / Math.RAD2DEG
        
        let yAdjust: CGFloat = coordinateSystem == .screen ? -1 : 1
        
        self.init(dx: CGFloat(sinf(Float(radians))), dy: CGFloat(cosf(Float(radians))) * yAdjust)
    }
    
    /**
     Creates a normalised vector at a random angle greater than the angle supplied and less than (angle + offset)
     
     - Parameters:
        - angle: the angle, in degrees, you would like the vector to be from the upper y-axis.
        - offSet: the number of degress within which the random vector can be defined
        - coordinateSystem: coordinate system self and vector are assumed to be in. The default is .cartersian.
     
     */
    init(randomAngleBetween angle: CGFloat, offSet: CGFloat, coordinateSystem: CoordinateSystem = .cartesian) {
        let randomAngle = CGFloat.random(in: angle ... angle + offSet)
        self.init(angle: randomAngle, coordinateSystem: coordinateSystem)
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

    static func == (lhs: CGVector, rhs: CGVector) -> Bool {
        return lhs.dx == rhs.dx && lhs.dy == rhs.dy
    }
}

