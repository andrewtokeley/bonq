//
//  Math.swift
//  bonq
//
//  Created by Andrew Tokeley on 2/05/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import UIKit

class Math {
    /**
    Constant which represents 180 degrees divided by pi. Useful when converting radians to degrees, simply multiple the radians amount by RAD2DEG.
     */
    static let RAD2DEG: CGFloat = 180.0 / CGFloat.pi
    
    /**
     Constant that represents 2 * pi
     */
    static let TWOPI = 2.0 * CGFloat.pi
    
}

extension CGFloat {
    
    func round(_ decimalPlaces: Int) -> CGFloat {
        let multiplier = CGFloat(pow(10, Double(decimalPlaces)))
        return (self * multiplier).rounded(.toNearestOrAwayFromZero) / multiplier
    }
    
}
