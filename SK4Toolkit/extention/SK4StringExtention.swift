//
//  SK4StringExtention.swift
//  SK4ToolKit
//
//  Created by See.Ku on 2016/03/27.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 垂直方向のAlignment
public enum SK4VerticalAlignment: Int {
	case Top
	case Center
	case Bottom
}

extension String {

	// /////////////////////////////////////////////////////////////
	// MARK: - トリミング

	/// 文字列の前後から空白文字を削除
	public func sk4TrimSpace() -> String {
		let cs = NSCharacterSet.whitespaceCharacterSet()
		return sk4Trim(cs)
	}

	/// 文字列の前後から空白文字と改行を削除
	public func sk4TrimSpaceNL() -> String {
		let cs = NSCharacterSet.whitespaceAndNewlineCharacterSet()
		return sk4Trim(cs)
	}

	/// 文字列の前後から指定した文字を削除
	public func sk4Trim(str: String) -> String {
		let cs = NSCharacterSet(charactersInString: str)
		return sk4Trim(cs)
	}

	/// 文字列の前後から指定した文字セットを削除
	public func sk4Trim(charSet: NSCharacterSet) -> String {
		return stringByTrimmingCharactersInSet(charSet)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 描画

	/// 指定された範囲の中央に文字列を描画
	public func sk4DrawAtCenter(rect: CGRect, withAttributes attrs: [String:AnyObject]?) {
		let size = nsString.sizeWithAttributes(attrs)
		let cx = rect.midX - size.width/2
		let cy = rect.midY - size.height/2
		nsString.drawAtPoint(CGPoint(x: cx, y: cy), withAttributes: attrs)
	}

	/// 垂直方向のアライメントを指定して、文字列を描画
	public func sk4DrawInRect(rect: CGRect, withAttributes attrs: [String:AnyObject]?, vertical: SK4VerticalAlignment = .Top) {
		var rect = rect
		let bound = nsString.boundingRectWithSize(rect.size, options: .UsesLineFragmentOrigin, attributes: attrs, context: nil)

		switch vertical {
		case .Top:
			break

		case .Center:
			rect.origin.y += (rect.height - bound.height) / 2

		case .Bottom:
			rect.origin.y += rect.height - bound.height
		}

		nsString.drawInRect(rect, withAttributes: attrs)
	}















	// /////////////////////////////////////////////////////////////
	// MARK: - フレームワーク内部で使用

	/// NSStringを取得
	var nsString: NSString {
		return (self as NSString)
	}

}

// eof
