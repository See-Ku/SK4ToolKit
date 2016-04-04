//
//  SK4CGSizeExtension.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

extension CGSize {

	/// 値をまとめて操作
	public var size: [CGFloat] {
		get {
			return [width, height]
		}

		set {
			switch newValue.count {
			case 0:
				clear()

			case 1:
				width = newValue[0]
				height = newValue[0]

			default:
				width = newValue[0]
				height = newValue[1]
			}
		}
	}

	/// 値は全て0か？
	public var isEmpty: Bool {
		if width == 0 && height == 0 {
			return true
		} else {
			return false
		}
	}

	/// 値を全て0にする
	public mutating func clear() {
		width = 0
		height = 0
	}

	/// 値をまとめて操作
	public mutating func set(val: CGFloat) {
		width = val
		height = val
	}

	/// 値をまとめて操作
	public mutating func set(width width: CGFloat, height: CGFloat) {
		self.width = width
		self.height = height
	}

}

// eof
