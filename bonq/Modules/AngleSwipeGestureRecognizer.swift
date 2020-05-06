//
//  UIAngleSwipeGestureRocognizer.swift
//  bonq
//
//  Created by Andrew Tokeley on 1/05/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import Foundation
import UIKit

class AngleSwipeGestureRecognizer: UIGestureRecognizer {
    
    private var startSwipePoint: CGPoint?
    private var endSwipePoint: CGPoint?
    
    // MARK: - Private Properties
    
    private var distanceBetweenStartAndEndTouches: CGFloat {
        if let startSwipePoint = self.startSwipePoint, let endSwipePoint = self.endSwipePoint {
            return startSwipePoint.distance(fromPoint: endSwipePoint)
        }
        return 0
    }
    
    // MARK: - Public Properties
    
    /**
     Delegate
     */
    var angleSwipeDelegate: AngleSwipeGestureRecognizerDelegate?
    
    /**
     The minimum angle allowable where 0 degrees is leftwards, along the ground. Default is 45 degrees
     */
    var angleMin: CGFloat = 45
    
    /**
     The maximum angle allowed where 180 degrees is rightwards, along the ground. Default is 135 degrees.
     */
    var angleMax: CGFloat = 135
    
    /**
     The angle, in degrees, that was actually gestured. The angle is measured assuming 0 degrees is left along the ground.
     */
    var angle: CGFloat {
        if let startSwipePoint = self.startSwipePoint, let endSwipePoint = self.endSwipePoint {
            return startSwipePoint.angle(toPoint: endSwipePoint)
        }
        return CGFloat.nan
    }
    
    var vector: CGVector {
        if let startSwipePoint = self.startSwipePoint, let endSwipePoint = self.endSwipePoint {
            return CGVector(dx:endSwipePoint.x - startSwipePoint.x, dy: startSwipePoint.y - endSwipePoint.y)
        } else {
            return CGVector.zero
        }
    }
    
    //MARK: - Overrides
    
    override func reset() {
        startSwipePoint = nil
        endSwipePoint = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touch = touches.first else {
          return
        }
        super.touchesBegan(touches, with: event)
        startSwipePoint = touch.location(in: self.view)
        self.state = .began
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        self.state = .changed
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        self.state = .cancelled
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touch = touches.first else {
          return
        }
        
        super.touchesEnded(touches, with: event)
        endSwipePoint = touch.location(in: self.view)
        
        let isAngleInRange = angleSwipeDelegate?.angleSwipeGesture(self, shouldAngleTriggerAction: angle) ?? true
        let requiredDistance = angleSwipeDelegate?.angleSwipeGestureDistance(self) ?? 40
        
        // check that the swipe was long enough and within the angle range specified by the angleSwipeDelegate
        if distanceBetweenStartAndEndTouches >= requiredDistance && isAngleInRange {
            state = .ended
        } else {
            self.reset()
        }
    }
}
