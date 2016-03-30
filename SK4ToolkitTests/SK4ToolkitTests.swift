//
//  SK4ToolkitTests.swift
//  SK4ToolkitTests
//
//  Created by See.Ku on 2016/03/23.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import XCTest
@testable import SK4Toolkit

class SK4ToolkitTests: XCTestCase {

/*
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
*/

	/// 乱数関係のテスト　※厳密なテストではない
	func testRandom() {

		// 乱数の生成（Int）
		let max1 = 11
		for _ in 0...100 {
			let no = sk4Random(max1)
			XCTAssert(no < max1)
		}

		// 乱数の生成（CGFloat）
		let max2: CGFloat = 13
		for _ in 0...100 {
			let no = sk4Random(max2)
			XCTAssert(no < max2)
		}

		// 乱数の生成（最小値／最大値）
		let min3 = 7
		let max3 = 17
		for _ in 0...100 {
			let no = sk4Random(min3..<max3)
			XCTAssert(min3 <= no && no < max3)
		}
	}

	/// 数学関係のテスト
	func testNearlyEqual() {

		/// 誤差の範囲内で一致するか？
		XCTAssert(sk4NearlyEqual(100, 101, dif: 1))
		XCTAssert(sk4NearlyEqual(100, 102, dif: 1) == false)
		XCTAssert(sk4NearlyEqual(3100, 3001, dif: 100))

		XCTAssert(sk4NearlyEqual(100.1, 101.1, dif: 1.0))
		XCTAssert(sk4NearlyEqual(100.1, 101.1, dif: 0.9) == false)
		XCTAssert(sk4NearlyEqual(1.1, 0.1, dif: 1.0))
	}

	/// 配列関係のテスト
	func testArray() {

		let ar1 = [1, 2, 3, 5, 7, 11]
		let ar2 = ["black", "white", "red", "green", "blue", "cyan"]

		/// 範囲内の場合だけ取得
		XCTAssert(sk4SafeGet(ar1, index: 1) != nil)
		XCTAssert(sk4SafeGet(ar1, index: 5) != nil)
		XCTAssert(sk4SafeGet(ar1, index: 6) == nil)

		XCTAssert(sk4SafeGet(ar2, index: 0) != nil)
		XCTAssert(sk4SafeGet(ar2, index: 3) != nil)
		XCTAssert(sk4SafeGet(ar2, index: 5) != nil)
		XCTAssert(sk4SafeGet(ar2, index: -1) == nil)
		XCTAssert(sk4SafeGet(ar2, index: 6) == nil)
	}
}

// eof
