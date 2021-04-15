//
//  HeartRecordingTests.swift
//  HeartRecordingTests
//
//  Created by 张子恒 on 2021/4/15.
//

import XCTest
@testable import HeartRecording

class HeartRecordingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFont() throws {
        var i = 0
        for family: String in UIFont.familyNames {
            print("\(i)---项目字体---\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
            i += 1
        }
    }

}
