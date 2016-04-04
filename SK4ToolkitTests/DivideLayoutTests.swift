//
//  DivideLayoutTests.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/04.
//  Copyright (c) 2015 AxeRoad. All rights reserved.
//

import XCTest
import SK4Toolkit

class DivideLayoutTests: XCTestCase {

	func testAdmin1() {

		// 横方向に2分割するレイアウト
		let dic: [String:AnyObject] = [
			"type":"divide",
			"divide.wx":2,		// 横方向に2分割
			"divide.wy":1		// 縦方向は分割なし
		]

		let mode = SK4DivideLayoutUnit(dic: dic)
		let admin = SK4DivideLayoutAdmin()
		admin.currentMode = mode

		// 表示範囲を指定
		let re = CGRect(x: 0, y: 0, width: 200, height: 100)
		admin.arrangeLayout(re)

		// 全部で2個に分割される
		XCTAssert(mode.children.count == 2)

		// 分割後のサイズを確認
		let child0 = mode.children[0]
		let re0 = CGRect(x: 0, y: 0, width: 100, height: 100)
		XCTAssert(child0.frame == re0)

		let child1 = mode.children[1]
		let re1 = CGRect(x: 100, y: 0, width: 100, height: 100)
		XCTAssert(child1.frame == re1)
	}

	func testAdmin2() {
		let dic: [String:AnyObject] = [
			"type":"divide",
			"divide.wx":1,		// 横方向は分割なし
			"divide.wy":3,		// 縦方向に3分割
			"units":[
				["type":"block1",	"unit_size":[0,100]],	// 高さ100で固定
				["type":"block2",	"unit_size":[0,0]],		// サイズ指定なし
				["type":"block3",	"unit_size":[0,0]]
			]
		]

		let mode = SK4DivideLayoutUnit(dic: dic)
		let admin = SK4DivideLayoutAdmin()
		admin.currentMode = mode

		// 範囲を指定してレイアウト
		let re = CGRect(x: 0, y: 0, width: 200, height: 160)
		admin.arrangeLayout(re)

		XCTAssert(mode.children.count == 3)

		// 最初のブロックは高さが固定
		let child0 = mode.children[0]
		let re0 = CGRect(x: 0, y: 0, width: 200, height: 100)
		XCTAssert(child0.frame == re0)

		// 残りのブロックは余った領域を等分割
		let child1 = mode.children[1]
		let re1 = CGRect(x: 0, y: 100, width: 200, height: 30)
		XCTAssert(child1.frame == re1)

		let child2 = mode.children[2]
		let re2 = CGRect(x: 0, y: 130, width: 200, height: 30)
		XCTAssert(child2.frame == re2)

		// ユニットを取得、自力で非表示に変更
		let ar = admin.searchUnitAll("block2")
		XCTAssert(ar.count == 1)
		for unit in ar {
			unit.hidden = true
		}

		// この状態で再レイアウト
		admin.arrangeLayout(re)
		XCTAssert(mode.children.count == 3)

		let child3 = mode.children[0]
		let re3 = CGRect(x: 0, y: 0, width: 200, height: 100)
		XCTAssert(child3.frame == re3)

		// 2個めのブロックは非表示
		let child4 = mode.children[1]
		let re4 = CGRect(x: 0, y: 100, width: 200, height: 0)
		XCTAssert(child4.frame == re4)

		// 3個目のブロックは残りの領域
		let child5 = mode.children[2]
		let re5 = CGRect(x: 0, y: 100, width: 200, height: 60)
		XCTAssert(child5.frame == re5)
	}

	func testAdmin3() {
		let dic: [String:AnyObject] = [
			"type":"divide",
			"divide.wx":3,		// 横方向に3分割
			"divide.wy":2,		// 縦方向に2分割
			"units":[
				["type":"block0",	"unit_size" : [40,50]],		// 幅40、高さ50で固定
				["type":"block1",	"unit_size" : [0,0]],		// サイズ指定なし
				["type":"block2",	"unit_size" : [0,0]],
				["type":"block3",	"unit_size" : [0,0]],
				["type":"block4",	"unit_size" : [0,0]],
				["type":"block5",	"unit_size" : [0,0]]
			]
		]

		let mode = SK4DivideLayoutUnit(dic: dic)
		let admin = SK4DivideLayoutAdmin()
		admin.currentMode = mode

		let re = CGRect(x: 0, y: 0, width: 100, height: 90)
		admin.arrangeLayout(re)

		XCTAssert(mode.children.count == 6)

		if let child0 = mode.getChildUnit(x: 0, y: 0) {
			let re0 = CGRect(x: 0, y: 0, width: 40, height: 50)
			XCTAssert(child0.frame == re0)
		} else {
			XCTFail("NG")
		}

		if let child1 = mode.getChildUnit(x: 1, y: 1) {
			let re1 = CGRect(x: 40, y: 50, width: 30, height: 40)
			XCTAssert(child1.frame == re1)
			XCTAssert(child1.unitType == "block4")
		} else {
			XCTFail("NG")
		}
	}

	func testAdmin4() {
		let dic: [String:AnyObject] = [
			"type":"divide",
			"divide.wx":1,		// 横方向に1分割
			"divide.wy":2,		// 縦方向に2分割
			"units":[
				["type":"block0-0",	"unit_size" : [0,20]],				// 高さ20で固定
				["type":"divide",										// サイズ指定なし
					"divide.wx":2,		// 横方向に2分割
					"divide.wy":1,		// 縦方向に1分割
					"units":[
						["type":"block1-0",	"unit_size" : [0,0]],		// サイズ指定なし
						["type":"block1-1",	"unit_size" : [40,0]],		// 幅40で固定
					]
				]
			]
		]

		let mode = SK4DivideLayoutUnit(dic: dic)
		let admin = SK4DivideLayoutAdmin()
		admin.currentMode = mode

		let re = CGRect(x: 0, y: 0, width: 100, height: 90)
		admin.arrangeLayout(re)

		XCTAssert(mode.children.count == 2)

		if let child0 = mode.getChildUnit(x: 0, y: 0) {
			let re = CGRect(x: 0, y: 0, width: 100, height: 20)
			XCTAssert(child0.frame == re)
		} else {
			XCTFail("NG")
		}

		if let child1 = mode.getChildUnit(x: 0, y: 1) {
			let re = CGRect(x: 0, y: 20, width: 100, height: 70)
			XCTAssert(child1.frame == re)

			if let child1x0 = child1.getChildUnit(x: 0, y: 0) {
				let re = CGRect(x: 0, y: 20, width: 60, height: 70)
				XCTAssert(child1x0.frame == re)
			} else {
				XCTFail("NG")
			}

			if let child1x1 = child1.getChildUnit(x: 1, y: 0) {
				let re = CGRect(x: 60, y: 20, width: 40, height: 70)
				XCTAssert(child1x1.frame == re)
			} else {
				XCTFail("NG")
			}
			
		} else {
			XCTFail("NG")
		}
	}

}

// eof
