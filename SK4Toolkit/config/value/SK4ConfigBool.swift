//
//  SK4ConfigBool.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/// Bool型の設定を管理するためのクラス
public class SK4ConfigBool: SK4ConfigGenerics<Bool> {

	/// BoolをStringに変換
	class func boolToString(value: Bool) -> String {
		return value ? "Yes" : "No"
	}

	/// StringをBoolに変換
	class func stringToBool(string: String) -> Bool {
		let str = string.sk4TrimSpaceNL().lowercaseString
		if str == "yes" || str == "true" {
			return true
		} else {
			return false
		}
	}

	// /////////////////////////////////////////////////////////////

	/// 値と文字列を変換
	override public var string: String {
		get {
			return SK4ConfigBool.boolToString(value)
		}

		set {
			value = SK4ConfigBool.stringToBool(newValue)
		}
	}

	/// 初期化
	override public init(title: String, value: Bool) {
		super.init(title: title, value: value)

		self.cell = SK4ConfigCellSwitch()
	}

	/// ランダムに変更
	override public func random() {
		if readOnly == false {
			if sk4Random(2) == 0 {
				value = false
			} else {
				value = true
			}
		}
	}

	/// Boolを反転
	public func flip() {
		value = !value
	}
}

// eof
