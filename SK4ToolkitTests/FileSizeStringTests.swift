//
//  FileSizeStringTests.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/06.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import XCTest
import SK4Toolkit

class FileSizeStringTests: XCTestCase {

	func testFileSizeToString() {
		let src: [UInt64] = [
			0,		10,		900,	999,
			1000,	1001,	1023,	1024,
			1025,	2000,	9999,	10000,
			10239,	10240,	10241,	10340,

			UInt64(1024*1024*10),
			UInt64(1024*1024*1024*10),
			UInt64(1024*1024*1024*1024*10),
			UInt64(1024*1024*1024*1024*1024*10),
			UInt64(1024*1024*1024*1024*1024*1024),
			UInt64.max
		]

		let dst: [String] = [
			"0 bytes",	"10 bytes",	"900 bytes",	"999 bytes",
			"1.0 KB",	"1.0 KB",	"1.0 KB",	"1.0 KB",
			"1.0 KB",	"2.0 KB",	"9.8 KB",	"9.8 KB",
			"10 KB",	"10 KB",	"10 KB",	"10 KB",
			"10 MB",	"10 GB",	"10 TB",	"10 PB",
			"1.0 EB",	"15 EB"
		]

		for i in 0..<src.count {
			let str = sk4FileSizeString(src[i])
			XCTAssert(str == dst[i])
		}
	}

}

// eof
