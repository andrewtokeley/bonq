//
//  RoundingTests.swift
//  bonqTests
//
//  Created by Andrew Tokeley on 10/05/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import XCTest
@testable import bonq

class RoundingTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

        
    func testRounding() {
        let x: CGFloat = 1.23456789
        let x2 = x.round(2)
        XCTAssert(x2 == 1.23)
        
        let x3 = x.round(3)
        XCTAssert(x3 == 1.235)
    }


}
