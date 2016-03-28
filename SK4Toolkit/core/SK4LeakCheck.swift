//
//  SK4LeakCheck.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/23.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

private var g_leakCheckTab = 0

/// メモリリークをチェックするためだけのクラス
public class SK4LeakCheck {
	let tab: Int
	let name: String

	public init(name: String) {
		self.tab = g_leakCheckTab
		self.name = name

		g_leakCheckTab += 1
		printState(">>")
	}

	deinit {
		printState("<<")
		g_leakCheckTab -= 1
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
