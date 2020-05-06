//
//  PointExtension.swift
//  bonq
//
//  Created by Andrew Tokeley on 2/05/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint {

    /**
     Returns the distance to another point.
     */
    func distance(fromPoint point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
    
    /**
     Returns the angle made to the given point, where 0 degrees means the point is directly above self.
     
     - Important: The angle assumes the points represent a screen coordinate where the x axis increases from left to right and the y axis increases from top to bottom (i.e. (0,0) is the top left of the screen).
     
     The example below would result in an angle of 135 degrees, if self was (0,0) and comparison point was (1, 1).
     
        ````
        (0,0) + ------- x
              |\
              |  \
              |    \
              |      + (1, 1)
              |
              y
        ````
     */
    func angle(toPoint point: CGPoint) -> CGFloat {
        guard !self.equalTo(point) else {
            return CGFloat.nan
        }
        
        var radians = atan2(point.x - self.x, self.y - point.y)
        if (radians < 0) {
            radians += Math.TWOPI;
        }
        return radians * Math.RAD2DEG;
    }
}
