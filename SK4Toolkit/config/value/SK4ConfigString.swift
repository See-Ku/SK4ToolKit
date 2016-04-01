//
//  SK4ConfigString.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/// String型の設定を管理するためのクラス
public class SK4ConfigString: SK4ConfigGenerics<String> {

	/// 値と文字列を相互に変換
	override public var string: String {
		get {
			return value
		}

		set {
			value = newValue
		}
	}

	/// 初期化
	override public init(title: String, value: String) {
		super.init(title: title, value: value)
	}

	/// 文字列の最大長を指定して初期化　※編集を有効にする
	public convenience init(title: String, value: String, maxLength: Int) {
		self.init(title: title, value: value)

		if maxLength != 0 && maxLength <= 32 {
			self.cell = SK4ConfigCellTextField(maxLength: maxLength)
		} else {
			self.cell = SK4ConfigCellTextView(maxLength: maxLength)
		}
	}
}

// eof
