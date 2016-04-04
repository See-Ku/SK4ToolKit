//
//  SK4UIEdgeInsetsExtension.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/04/02.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

	/// 値をまとめて操作
	public var insets: [CGFloat] {
		get {
			return [top, right, bottom, left]
		}

		set {
			switch newValue.count {
			case 0:
				clear()

			case 1:	// [上下左右]
				top = newValue[0]
				bottom = newValue[0]
				left = newValue[0]
				right = newValue[0]

			case 2:	// [上下][左右]
				top = newValue[0]
				bottom = newValue[0]
				left = newValue[1]
				right = newValue[1]

			case 3:	// [上][左右][下]
				top = newValue[0]
				left = newValue[1]
				right = newValue[1]
				bottom = newValue[2]

			default:	// [上][右][下][左]
				top = newValue[0]
				right = newValue[1]
				bottom = newValue[2]
				left = newValue[3]
			}
		}
	}

	/// 値は全て0か？
	public var isEmpty: Bool {
		if top != 0 || right != 0 || bottom != 0 || left != 0 {
			return false
		} else {
			return true
		}
	}

	/// 値を全て0にする
	public mutating func clear() {
		top = 0
		right = 0
		bottom = 0
		left = 0
	}

	/// マージンを取り除いた矩形を生成
	public func insetRect(rect: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(rect, self)
	}
	
}

// eof
