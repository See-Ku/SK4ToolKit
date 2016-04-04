//
//  StringExtensionTests.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import XCTest
import SK4Toolkit

class StringExtensionTests: XCTestCase {

	func testString() {

		let base = "12345678"

		// /////////////////////////////////////////////////////////////
		// sk4SubstringToIndex

		// 先頭から４文字を取得
		XCTAssert(base.sk4SubstringToIndex(4) == "1234")

		// 先頭から０文字を取得 ＝ ""
		XCTAssert(base.sk4SubstringToIndex(0) == "")

		// 文字列の長さを超えた場合、全体を返す
		XCTAssert(base.sk4SubstringToIndex(12) == "12345678")

		// 先頭より前を指定された場合、""を返す
		XCTAssert(base.sk4SubstringToIndex(-4) == "")

		// /////////////////////////////////////////////////////////////
		// sk4SubstringFromIndex

		// ４文字目以降を取得
		XCTAssert(base.sk4SubstringFromIndex(4) == "5678")

		// ０文字目以降をを取得
		XCTAssert(base.sk4SubstringFromIndex(0) == "12345678")

		// 文字列の長さを超えた場合""を返す
		XCTAssert(base.sk4SubstringFromIndex(12) == "")

		// 先頭より前を指定された場合、全体を返す
		XCTAssert(base.sk4SubstringFromIndex(-4) == "12345678")

		// /////////////////////////////////////////////////////////////
		// sk4SubstringWithRange

		// ２文字目から６文字目までを取得
		XCTAssert(base.sk4SubstringWithRange(start: 2, end: 6) == "3456")

		// ０文字目から４文字目までを取得
		XCTAssert(base.sk4SubstringWithRange(start: 0, end: 4) == "1234")

		// ４文字目から８文字目までを取得
		XCTAssert(base.sk4SubstringWithRange(start: 4, end: 8) == "5678")

		// 範囲外の指定は範囲内に丸める
		XCTAssert(base.sk4SubstringWithRange(start: -2, end: 3) == "123")
		XCTAssert(base.sk4SubstringWithRange(start: 5, end: 12) == "678")
		XCTAssert(base.sk4SubstringWithRange(start: -3, end: 15) == "12345678")

		// Rangeでの指定も可能
		XCTAssert(base.sk4SubstringWithRange(1 ..< 4) == "234")

		// /////////////////////////////////////////////////////////////
		// sk4TrimSpace

		// 文字列の前後から空白文字を取り除く
		XCTAssert("  abc  def\n  ".sk4TrimSpace() == "abc  def\n")

		// 文字列の前後から空白文字と改行を取り除く
		XCTAssert("  abc  def\n  ".sk4TrimSpaceNL() == "abc  def")

		// 全角空白も対応
		XCTAssert("　　どうかな？　　".sk4TrimSpaceNL() == "どうかな？")

		// 何も残らない場合は""になる
		XCTAssert("  \n  \n  ".sk4TrimSpaceNL() == "")
		XCTAssert("".sk4TrimSpaceNL() == "")
	}

	func testConvert() {
		let str = "1234"

		// utf8エンコードでNSDataに変換
		if let data = str.sk4ToNSData() {
			//			println(data1)
			XCTAssert(data.description == "<31323334>")
		} else {
			XCTFail("Fail")
		}

		// Base64をデコードしてNSDataに変換
		if let data = str.sk4Base64Decode() {
			//			println(data2)
			XCTAssert(data.description == "<d76df8>")
		} else {
			XCTFail("Fail")
		}

		let empty = ""

		// utf8エンコードでNSDataに変換
		if let data = empty.sk4ToNSData() {
			XCTAssert(data.length == 0)
		} else {
			XCTFail("Fail")
		}

		// Base64をデコードしてNSDataに変換
		if let data = empty.sk4Base64Decode() {
			XCTAssert(data.length == 0)
		} else {
			XCTFail("Fail")
		}
	}

}

// eof
