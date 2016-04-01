//
//  ConfigAdminTests.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import XCTest
import SK4Toolkit

class ConfigAdminTests: XCTestCase {

	func testAdmin() {

		let admin1 = SK4ConfigAdmin()
		XCTAssert(admin1.title == "admin")

		let cv1 = SK4ConfigInt(title: "Int1", value: 100)
		let cv2 = SK4ConfigInt(title: "Int2", value: 200)
		let cv3 = SK4ConfigInt(title: "Int3", value: 300)

		let sec1 = admin1.addUserSection("Section1")
		sec1.addConfig(cv1)
		sec1.addConfig(cv2)

		let hide = admin1.getHideSection()
		hide.addConfig(cv3)
		XCTAssert(hide.name == "----")

		XCTAssert(cv1.configAdmin === admin1)
		XCTAssert(cv2.configAdmin === admin1)
		XCTAssert(cv3.configAdmin === admin1)
		XCTAssert(adminDesc(admin1) == "/admin/Section1|Int1: 100\n/admin/Section1|Int2: 200\n/admin/----|Int3: 300\n")

		// push/pop　※内部設定用のセクションには影響しない
		admin1.push()
		cv1.value = 111
		cv2.value = 222
		cv3.value = 333
		XCTAssert(adminDesc(admin1) == "/admin/Section1|Int1: 111\n/admin/Section1|Int2: 222\n/admin/----|Int3: 333\n")

		admin1.pop()
		XCTAssert(adminDesc(admin1) == "/admin/Section1|Int1: 100\n/admin/Section1|Int2: 200\n/admin/----|Int3: 333\n")

		// reset　※内部設定用のセクションには影響しない
		cv1.value = 1110
		cv2.value = 2220
		cv3.value = 3330
		XCTAssert(adminDesc(admin1) == "/admin/Section1|Int1: 1110\n/admin/Section1|Int2: 2220\n/admin/----|Int3: 3330\n")

		admin1.reset()
		XCTAssert(adminDesc(admin1) == "/admin/Section1|Int1: 100\n/admin/Section1|Int2: 200\n/admin/----|Int3: 3330\n")
	}

	func testAdmin2() {

		let admin1 = SK4ConfigAdmin(title: "Global Config")
		XCTAssert(admin1.title == "Global Config")
	}
	
	func testAdminDir() {

		let root = SK4ConfigAdmin(title: "root")
		let sec1 = root.addUserSection("Section1")
		let cv1 = SK4ConfigInt(title: "Int1", value: 100)
		sec1.addConfig(cv1)

		let sub = SK4ConfigAdmin(title: "sub")
		let sec2 = sub.addUserSection("Section2")
		let cv2 = SK4ConfigInt(title: "Int2", value: 200)
		sec2.addConfig(cv2)

		sec1.addConfig(sub)
		XCTAssert(adminDesc(root) == "/root/Section1|Int1: 100\n/root/Section1|sub: \n/root/Section1/sub/Section2|Int2: 200\n")

		// push/pop　※内部設定用のセクションには影響しない
		root.push()
		cv1.value = 111
		sub.value = "aaa"
		cv2.value = 222
		XCTAssert(adminDesc(root) == "/root/Section1|Int1: 111\n/root/Section1|sub: aaa\n/root/Section1/sub/Section2|Int2: 222\n")

		root.pop()
		XCTAssert(adminDesc(root) == "/root/Section1|Int1: 100\n/root/Section1|sub: \n/root/Section1/sub/Section2|Int2: 200\n")

		// reset
		root.push()
		cv1.value = 111
		sub.value = "aaa"
		cv2.value = 222
		XCTAssert(adminDesc(root) == "/root/Section1|Int1: 111\n/root/Section1|sub: aaa\n/root/Section1/sub/Section2|Int2: 222\n")

		root.reset()
		XCTAssert(adminDesc(root) == "/root/Section1|Int1: 100\n/root/Section1|sub: \n/root/Section1/sub/Section2|Int2: 200\n")

//		let tmp = adminDesc(root)
//		print("admin1: \n\(tmp)")
//		print("---")
	}

	func adminDesc(admin: SK4ConfigAdmin) -> String {
		var desc = ""
		admin.execConfig(all: true) { path, cv in
			desc += "\(path)|\(cv)\n"
		}
		return desc
	}
}

// eof
