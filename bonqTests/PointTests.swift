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

class PointTests: XCTestCase {

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

}
