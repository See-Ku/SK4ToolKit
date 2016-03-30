//
//  PauseFlagTests.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import XCTest
import SK4Toolkit

class PauseFlagTests: XCTestCase {

	/// 初期化
	func testPauseFlagInit() {
		let flag1 = SK4PauseFlag()
		XCTAssert(flag1.flag == false)

		let flag2 = SK4PauseFlag(enable: false, pause: false)
		XCTAssert(flag2.flag == false)

		let flag3 = SK4PauseFlag(enable: false, pause: true)
		XCTAssert(flag3.flag == false)

		let flag4 = SK4PauseFlag(enable: true, pause: false)
		XCTAssert(flag4.flag == true)

		let flag5 = SK4PauseFlag(enable: true, pause: true)
		XCTAssert(flag5.flag == false)
	}

	/// フラグ操作
	func testPauseFlag() {

		let flag1 = SK4PauseFlag()

		// 許可する ＝ flagをtrueに
		flag1.enable()
		XCTAssert(flag1.flag == true)

		// 許可してる状態で一時停止
		flag1.pause()
		XCTAssert(flag1.flag == false)

		// 一時停止を解除
		flag1.resume()
		XCTAssert(flag1.flag == true)


		// 不許可にする ＝ flagをfalseに
		// ※一時停止側のflagは影響されない
		flag1.disable()
		XCTAssert(flag1.flag == false)

		// 不許可の状態で一時停止
		flag1.pause()
		XCTAssert(flag1.flag == false)

		// 一時停止を解除
		flag1.resume()
		XCTAssert(flag1.flag == false)
	}
}

// eof
