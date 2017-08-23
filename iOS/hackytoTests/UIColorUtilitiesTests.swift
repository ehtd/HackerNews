//
//  UIColorUtilitiesTests.swift
//  hackytoTests
//
//  Created by Ernesto Torres on 8/22/17.
//  Copyright © 2017 Ernesto Torres. All rights reserved.
//

import XCTest

class UIColorUtilitiesTests: XCTestCase {
    
    func testUIColorGeneratedFromHexHasCorrectComponents() {
        let color = UIColor.fromInt(0x112233)

        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let multiplier: CGFloat = 255.0
        let r = (CGFloat)(0x11)
        let g = (CGFloat)(0x22)
        let b = (CGFloat)(0x33)

        XCTAssertTrue(red * multiplier == r)
        XCTAssertTrue(green * multiplier == g)
        XCTAssertTrue(blue * multiplier == b)
    }
    
}
