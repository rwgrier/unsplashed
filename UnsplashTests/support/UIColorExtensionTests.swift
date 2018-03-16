//
//  UIColorExtensionTests.swift
//  UnsplashTests
//
//  Created by Ryan Grier on 3/15/18.
//  Copyright © 2018 Ryan Grier. All rights reserved.
//

import XCTest
@testable import Unsplash

class UIColorExtensionTests: XCTestCase {
    func testColorFromHex() {
        let input = "000000"
        let test = UIColor(hex: input)
        let expected = UIColor(red: 0, green: 0, blue: 0, alpha: 1)

        XCTAssertNotNil(test)
        XCTAssertEqual(test, expected)
    }

    func testColorFromHexWithHash() {
        let input = "#FFFFFF"
        let test = UIColor(hex: input)
        let expected = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

        XCTAssertNotNil(test)
        XCTAssertEqual(test, expected)
    }
}
