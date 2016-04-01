//
//  SK4ConfigCGFloat.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// CGFloat型の設定を管理するためのクラス
public class SK4ConfigCGFloat: SK4ConfigGenerics<CGFloat> {

	/// 値と文字列を相互に変換
	override public var string: String {
		get {
			return String(format: "%0.2f", Double(value))
		}

		set {
			let val = newValue.nsString.floatValue
			value = CGFloat(val)
		}
	}

	/// 初期化
	override public init(title: String, value: CGFloat) {
		super.init(title: title, value: value)
	}
}

// eof
