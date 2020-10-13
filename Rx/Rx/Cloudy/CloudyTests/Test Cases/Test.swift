//
//  Test.swift
//  CloudyTests
//
//  Created by HuyHoangDinh on 9/28/20.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import XCTest
import SwiftyMocky
class Test: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let mock = SettingsTimeViewModelAbstractMock()

        mock.given(.justTestFunction(str: .any, willReturn: "case 1"))
        mock.given(.justTestFunction(str: .value("case 2"), willReturn: "case 2"))
        mock.given(.justTestFunction(str: .value("case 2"), willReturn: "case 0"))
        XCTAssertEqual(mock.justTestFunction(str: "case 2"), "case 0")
        Verify(mock, .justTestFunction(str: "case 2"))
        
    }

}
