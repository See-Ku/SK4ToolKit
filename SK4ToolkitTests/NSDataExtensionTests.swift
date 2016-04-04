//
//  NSDataExtensionTests.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/04.
//  Copyright (c) 2015 AxeRoad. All rights reserved.
//

import XCTest
import SK4Toolkit

class NSDataExtensionTests: XCTestCase {

	func testConvert() {

		do {
			let str = "1234"

			// NSData経由でBase64に
			let data = str.sk4ToNSData()
			XCTAssert(data != nil)

			let tmp = data!.sk4ToString()
			XCTAssert(tmp == str)

			let tmp2 = data!.sk4Base64Encode()
			XCTAssert(tmp2 == "MTIzNA==")

			// Base64をデコード
			let decode = tmp2.sk4Base64Decode()
			XCTAssert(decode != nil)

			let tmp3 = decode!.sk4ToString()
			XCTAssert(tmp3 == str)
		}

		do {
			let str = ""

			// NSData経由でBase64に
			let data = str.sk4ToNSData()
			XCTAssert(data != nil)

			let tmp = data!.sk4ToString()
			XCTAssert(tmp == str)

			let tmp2 = data!.sk4Base64Encode()
			XCTAssert(tmp2 == "")
		}
	}

}

// eof
