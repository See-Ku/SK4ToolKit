//
//  SK4StringExtention.swift
//  SK4Toolkit
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
	// MARK: - ローカライズ

	/// ローカライズした文字列を取得
	public var loc: String {
		return NSLocalizedString(self, comment: self)
	}

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
	// MARK: - 部分文字列

	/// 先頭からindexまでの部分文字列を作成する　※範囲チェックあり
	public func sk4SubstringToIndex(index: Int) -> String {
		if index <= 0 {
			return ""
		} else if characters.count <= index {
			return self
		} else {
			let pos = startIndex.advancedBy(index)
			return substringToIndex(pos)
		}
	}

	/// indexから末尾までの部分文字列を作成する　※範囲チェックあり
	public func sk4SubstringFromIndex(index: Int) -> String {
		if index <= 0 {
			return self
		} else if characters.count <= index {
			return ""
		} else {
			let pos = startIndex.advancedBy(index)
			return substringFromIndex(pos)
		}
	}

	/// 指定された範囲の部分文字列を作成する　※範囲チェックあり
	public func sk4SubstringWithRange(start start: Int, end: Int) -> String {
		if start >= end {
			return ""
		} else {
			let len = characters.count
			let p0 = startIndex.advancedBy(max(0, start))
			let p1 = startIndex.advancedBy(min(len, end))
			return substringWithRange(p0 ..< p1)
		}
	}

	/// 指定された範囲の部分文字列を作成する　※範囲チェックあり
	public func sk4SubstringWithRange(range: Range<Int>) -> String {
		return sk4SubstringWithRange(start: range.startIndex, end: range.endIndex)
	}

	/// 文字列の分割
	public func sk4Split(separater: String) -> [String] {
		return componentsSeparatedByString(separater)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 正規表現

	/// 正規表現でマッチング
	public func sk4RegularExpression(pattern: String, options: NSRegularExpressionOptions = []) -> [String] {
		do {
			let rex = try NSRegularExpression(pattern: pattern, options: options)
			let ar = rex.matchesInString(self, options: [], range: NSRange(location: 0, length: nsString.length))
			return ar.map() { rc in
				return self.nsString.substringWithRange(rc.range)
			}
		} catch {
			assertionFailure("Wrong regular expression. str: \(self) pat:\(pattern)")
			return []
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - データ変換

	/// 文字列からNSDataを生成
	public func sk4ToNSData() -> NSData? {
		return nsString.dataUsingEncoding(NSUTF8StringEncoding)
	}

	/// Base64文字列をNSDataにデコード
	public func sk4Base64Decode(options: NSDataBase64DecodingOptions = .IgnoreUnknownCharacters) -> NSData? {
		return NSData(base64EncodedString: self, options: options)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - JSON

	/// JSON形式の文字列からNSDictionaryを生成
	public func sk4JsonToDic(options: NSJSONReadingOptions = []) -> NSDictionary? {
		guard let data = sk4ToNSData() else { return nil }

		do {
			if let dic = try NSJSONSerialization.JSONObjectWithData(data, options: options) as? NSDictionary {
				return dic
			}
		} catch {
			sk4DebugLog("JSONObjectWithData error: \(error)")
		}

		return nil
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - ファイル入出力

	/// ファイルを読み込み
	static public func sk4ReadFile(path: String) -> String? {
		do {
			return try String(contentsOfFile: path)
		} catch {
			return nil
		}
	}

	/// ファイルに書き出し
	public func sk4WriteFile(path: String) -> Bool {
		do {
			try writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
			return true
		} catch {
			return false
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - ファイル名

	/// ディレクトリの文字列にファイル名を連結
	public func sk4AppendingPath(fn: String) -> String {
		return nsString.stringByAppendingPathComponent(fn)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 描画

	/// 描画範囲を示す矩形を取得
	public func sk4BoundingRect(size: CGSize, options: NSStringDrawingOptions = .UsesLineFragmentOrigin, attributes: [String : AnyObject]? = nil, context: NSStringDrawingContext? = nil) -> CGRect {
		return self.boundingRectWithSize(size, options: options, attributes: attributes, context: context)
	}

	/// 指定された範囲の中央に文字列を描画
	public func sk4DrawAtCenter(rect: CGRect, withAttributes attrs: [String:AnyObject]?) {
		let size = self.sizeWithAttributes(attrs)
		let cx = rect.midX - size.width/2
		let cy = rect.midY - size.height/2
		self.drawAtPoint(CGPoint(x: cx, y: cy), withAttributes: attrs)
	}

	/// 垂直方向のアライメントを指定して、文字列を描画
	public func sk4DrawInRect(rect: CGRect, withAttributes attrs: [String:AnyObject]?, vertical: SK4VerticalAlignment = .Top) {
		var rect = rect
		let bound = sk4BoundingRect(rect.size, attributes: attrs)

		switch vertical {
		case .Top:
			break

		case .Center:
			let dif = (rect.height - bound.height) / 2
			rect.origin.y += dif
			rect.size.height -= dif

		case .Bottom:
			let dif = rect.height - bound.height
			rect.origin.y += dif
			rect.size.height -= dif
		}

		self.drawInRect(rect, withAttributes: attrs)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - フレームワーク内部で使用

	/// NSStringを取得
	public var nsString: NSString {
		return (self as NSString)
	}
}

// eof
