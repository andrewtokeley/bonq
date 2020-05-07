//
//  UIAngleSwipeGestureRecognizerDelegate.swift
//  bonq
//
//  Created by Andrew Tokeley on 2/05/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import CoreGraphics

protocol AngleSwipeGestureRecognizerDelegate {
    
    /**
     Asks the delegate whether the swipe angle should trigger the action.
     
     - Parameters:
        - shouldAngleTriggerAction: angle in dgrees
     
     */
    func angleSwipeGesture(_ gesture: AngleSwipeGestureRecognizer, shouldAngleTriggerAction angle: CGFloat) -> Bool
    
    /**
     The distance the swipe gesture must achieve in order to trigger the action.
     */
    func angleSwipeGestureDistance(_ gesture: AngleSwipeGestureRecognizer) -> CGFloat
    
}
