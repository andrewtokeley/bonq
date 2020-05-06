//
//  GeometryTests.swift
//  bonqTests
//
//  Created by Andrew Tokeley on 2/05/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import XCTest
import CoreGraphics

@testable import bonq

class GeometryTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /**
        Test angle created at 45* anticlockwise from vertical
     */
    func testAngleBetween2Points_135() {
        let point1 = CGPoint(x:0, y:0)
        let point2 = CGPoint(x:1, y:1)
        let angle = point1.angle(toPoint: point2)
        
        XCTAssert(angle == 135)
    }

    func testAngleBetween2Points_90() {
        let point1 = CGPoint(x:0, y:0)
        let point2 = CGPoint(x:1, y:0)
        let angle = point1.angle(toPoint: point2)
        
        XCTAssert(angle == 90)
    }
    
    func testAngleBetween2Points_180() {
        let point1 = CGPoint(x:0, y:0)
        let point2 = CGPoint(x:0, y:1)
        let angle = point1.angle(toPoint: point2)
        
        XCTAssert(angle == 180)
    }
    
    func testAngleBetween2Points_270() {
        let point1 = CGPoint(x:0, y:0)
        let point2 = CGPoint(x:-1, y:0)
        let angle = point1.angle(toPoint: point2)
        
        XCTAssert(angle == 270)
    }
    
    func testAngleBetween2PointsTheSame() {
        let point1 = CGPoint(x:0, y:0)
        let point2 = CGPoint(x:0, y:0)
        let angle = point1.angle(toPoint: point2)
        
        XCTAssert(angle.isNaN)
    }
    
    func testRounding() {
        let x: CGFloat = 1.23456789
        let x2 = x.round(2)
        XCTAssert(x2 == 1.23)
        
        let x3 = x.round(3)
        XCTAssert(x3 == 1.235)  
    }
    
    
    func testVectorFromAngle_90() {
        let vectorScreen = CGVector(angle: 90.0, coordinateSystem: .screen)
        XCTAssert(vectorScreen.dx == 1)
        XCTAssert(vectorScreen.dy.round(4) == 0)
        XCTAssert(vectorScreen.length.round(4) == 1)
        
        let vectorSpriteKit = CGVector(angle: 90, coordinateSystem: .spriteKit)
        XCTAssert(vectorSpriteKit.dx == 1)
        XCTAssert(vectorSpriteKit.dy.round(4) == 0)
        
    }

}
