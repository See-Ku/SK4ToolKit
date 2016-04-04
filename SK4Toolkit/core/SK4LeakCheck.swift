//
//  SK4LeakCheck.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/23.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/// メモリリークをチェックするためだけのクラス
public class SK4LeakCheck {

	static var leakCheckTab = 0

	let tab: Int
	let name: String

	public init(name: String) {
		self.tab = SK4LeakCheck.leakCheckTab
		self.name = name

		#if DEBUG
			SK4LeakCheck.leakCheckTab += 1
			printState(">>")
		#endif
	}

	deinit {
		#if DEBUG
			printState("<<")
			SK4LeakCheck.leakCheckTab -= 1
		#endif
	}

	func printState(mes: String) {
		let no = String(format: "%02d", tab + 1)
		var skip = no + mes
		for _ in 0..<tab {
			skip += "  "
		}
		print("\(skip)\(name)")
	}
}

// eof
