//
//  VectorTests.swift
//  bonqTests
//
//  Created by Andrew Tokeley on 10/05/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import XCTest
import CoreGraphics

@testable import bonq

class VectorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testVectorFromAngle_90() {
        let vectorScreen = CGVector(angle: 90.0, coordinateSystem: .screen)
        XCTAssert(vectorScreen.dx == 1)
        XCTAssert(vectorScreen.dy.round(4) == 0)
        XCTAssert(vectorScreen.magnitude.round(4) == 1)
        
        let vectorSpriteKit = CGVector(angle: 90, coordinateSystem: .cartesian)
        XCTAssert(vectorSpriteKit.dx == 1)
        XCTAssert(vectorSpriteKit.dy.round(4) == 0)
        
    }
    
    func testVectorFromAngleGreaterThan360() {
        // we would expect this to return the same result as a 90 degree angle
        let vector450 = CGVector(angle: 360+90, coordinateSystem: .cartesian)
        let vector90 = CGVector(angle: 90, coordinateSystem: .cartesian)
        
        XCTAssert(vector450.dx == 1)
        XCTAssert(vector450.dy.round(4) == 0)
        
        XCTAssert(vector90.dx == 1)
        XCTAssert(vector90.dy.round(4) == 0)
    }

    func testAngleTo_cartesian() {
        
        let vertical = CGVector(dx: 0, dy: 1)
        let vector1 = CGVector(angle: 83, coordinateSystem: .cartesian)
        XCTAssert(vector1.angleTo(vertical).round(0) == 83)
        
        let vector2 = CGVector(angle: 120, coordinateSystem: .cartesian)
        XCTAssert(vector2.angleTo(vertical).round(0) == 120)
        
        let vector3 = CGVector(angle: -73, coordinateSystem: .cartesian)
        XCTAssert(vector3.angleTo(vertical).round(0) == -73)
        
        let vector4 = CGVector(angle: 200, coordinateSystem: .cartesian)
        XCTAssert(vector4.angleTo(vertical).round(0) == -160)
    }
    
    func testAngleToProperty_screen() {
        
        let vertical = CGVector(dx: 0, dy: -1)
        let vector1 = CGVector(angle: 83, coordinateSystem: .screen)
        XCTAssert(vector1.angleTo(vertical, coordinateSystem: .screen).round(0) == 83)
        
        let vector2 = CGVector(angle: 120, coordinateSystem: .screen)
        XCTAssert(vector2.angleTo(vertical, coordinateSystem: .screen).round(0) == 120)
        
        let vector3 = CGVector(angle: -73, coordinateSystem: .screen)
        XCTAssert(vector3.angleTo(vertical, coordinateSystem: .screen).round(0) == -73)
        
        let vector4 = CGVector(angle: 200, coordinateSystem: .screen)
        XCTAssert(vector4.angleTo(vertical, coordinateSystem: .screen).round(0) == -160)
        
    }
    
    func testRandomVector_cartesian() {
        let LOWER_ANGLE: CGFloat = -90
        let OFFSET: CGFloat = 180
        let vertical = CGVector(dx: 0, dy: 1)
        
        for _ in 1 ... 10 {
            let vector = CGVector(randomAngleBetween: LOWER_ANGLE, offSet: OFFSET, coordinateSystem: .cartesian)
            let angle = vector.angleTo(vertical, coordinateSystem: .cartesian).round(0)
            XCTAssert(angle >= LOWER_ANGLE && angle <= LOWER_ANGLE + OFFSET, "\(angle) out of range")
        }
    }
    
    func testRandomVector_screen() {
        let LOWER_ANGLE: CGFloat = -90
        let OFFSET: CGFloat = 180
        let vertical = CGVector(dx: 0, dy: -1)

        for _ in 1 ... 10 {
            let vector = CGVector(randomAngleBetween: LOWER_ANGLE, offSet: OFFSET, coordinateSystem: .screen)
            let angle = vector.angleTo(vertical, coordinateSystem: .screen).round(0)
            XCTAssert(angle >= LOWER_ANGLE && angle <= LOWER_ANGLE + OFFSET, "\(angle) out of range")
        }
    }
    
}
